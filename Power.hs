{-# OPTIONS_GHC -Wall -fno-warn-orphans #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE RankNTypes                 #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
------------------------------------------------------------------------
-- Power Example Section 4.5
------------------------------------------------------------------------
module Power where

import Control.Applicative
import Control.Monad
import Data.Typeable
import Prelude hiding (abs,div)
import qualified Prelude as P

caseEither :: Either a b -> (a -> c) -> (b -> c) -> c
caseEither l m n = either m n l

-- Continuation Monad
---------------------
-- begin

data Cnt c b where
  Cnt :: (forall a. Typeable a => (b -> c a) -> c a) -> Cnt c b

runCnt :: Cnt c b -> (forall a. Typeable a => (b -> c a) -> c a)
runCnt (Cnt k) = k

shift :: (forall a. Typeable a => (b -> c a) -> c a) -> Cnt c b
shift k = Cnt k

reset :: Typeable c => Cnt trm (trm c) -> trm c
reset m = runCnt m id

instance Monad (Cnt trm) where
  return x = Cnt (\ k -> k x)
  m >>= f  = Cnt (\ k -> runCnt m (\ x -> runCnt (f x) k))

instance Functor (Cnt trm) where
  fmap  = liftA

instance Applicative (Cnt trm) where
  pure  = return
  (<*>) = ap

-- end
------

-- Syntax
---------
-- begin

class Trm trm where
  rat :: Rational -> trm Rational
  eql :: trm Rational -> trm Rational -> trm (Either () ())
  mul :: trm Rational -> trm Rational -> trm Rational
  div :: trm Rational -> trm Rational -> trm Rational
  unt :: trm ()
  abs :: (Typeable a , Typeable b) =>
         (trm a -> trm b) -> trm (a -> b)
  app :: Typeable a =>
         trm (a -> b) -> trm a -> trm b
  prd :: (Typeable a , Typeable b) =>
         trm a -> trm b -> trm (a , b)
  pi1 :: Typeable b =>
         trm (a , b) -> trm a
  pi2 :: Typeable a =>
         trm (a , b) -> trm b
  inl :: (Typeable a , Typeable b) =>
         trm a -> trm (Either a b)
  inr :: (Typeable a , Typeable b) =>
         trm b -> trm (Either a b)
  cas :: (Typeable a , Typeable b) =>
         trm (Either a b) ->
         trm (a -> c) -> trm (b -> c) -> trm c

-- end
------

-- Relation for defining semantic domain
----------------------------------------
-- Begin

type family Not p where
  Not 'True  = 'False
  Not 'False = 'True

data Rel (p :: Bool) trm a b where
  CnvT :: Rel 'True  trm b a' -> (a -> b) -> Rel 'True  trm a a'
  CnvF :: Rel 'False trm a a' -> (a -> b) -> Rel 'False trm b a'
  ExpT :: Rel p trm (trm a) a
  OneT :: Rel p trm () ()
  ArrT :: (Typeable a' , Typeable b') =>
          Rel (Not p) trm a a' -> Rel p trm b b' ->
          Rel p trm (a -> Cnt trm b) (a' -> b')
  PrdT :: (Typeable a' , Typeable b') =>
          Rel p trm a a' -> Rel p trm b b' ->
          Rel p trm (a , b)      (a' , b')
  SumT :: (Typeable a' , Typeable b') =>
          Rel p trm a a' -> Rel p trm b b' ->
          Rel p trm (Either a b) (Either a' b')

-- end
------

-- Evaluation
-------------
-- begin

data PossibleVal trm = Exp (trm Rational)
                     | Val Rational

type family   Eval (trm :: * -> *) a
type instance Eval  trm Rational     = PossibleVal trm
type instance Eval  trm ()           = ()
type instance Eval  trm (a -> b)     = Eval trm a -> Cnt trm (Eval trm b)
type instance Eval  trm (a , b)      = (Eval trm  a , Eval trm b)
type instance Eval  trm (Either a b) = Either (Eval trm a) (Eval trm b)

type BoolT = Either () ()

toBool :: BoolT -> Bool
toBool (Left  ()) = False
toBool (Right ()) = True

fromBool :: Bool -> BoolT
fromBool False = Left ()
fromBool True  = Right ()

ifT :: (Typeable a , Trm trm) => trm BoolT -> trm a -> trm a -> trm a
ifT l m n = cas l (abs (\ x -> n)) (abs (\ y -> m))

type MaybeT a = Either a ()

justT :: (Typeable a, Trm trm) => trm a -> trm (MaybeT a)
justT x       = inl x

nothingT :: (Typeable a, Trm trm) => trm (MaybeT a)
nothingT      = inr unt

maybeT m n l  = cas l (abs (\ x -> m `app` x)) (abs (\ y -> n))
l <$$> m      = maybeT (abs (\ x -> justT (l `app` x))) nothingT m

eqlv :: Trm trm => PossibleVal trm -> PossibleVal trm -> Cnt trm (Either () ())
eqlv (Val v) (Val w) = return (fromBool (v == w))
eqlv (Val v) (Exp n) = reflect (SumT OneT OneT) (eql (rat v) n)
eqlv (Exp m) (Val w) = reflect (SumT OneT OneT) (eql m (rat w))
eqlv (Exp m) (Exp n) = reflect (SumT OneT OneT) (eql m n)

mulv :: Trm trm => PossibleVal trm -> PossibleVal trm -> Cnt trm (PossibleVal trm)
mulv (Val v) (Val w) = return (Val (v * w))
mulv (Val 1) (Exp n) = return (Exp n)
mulv (Val v) (Exp n) = return (Exp (mul (rat v) n))
mulv (Exp m) (Val 1) = return (Exp m)
mulv (Exp m) (Val w) = return (Exp (mul m (rat w)))
mulv (Exp m) (Exp n) = return (Exp (mul m n))

divv :: Trm trm => PossibleVal trm -> PossibleVal trm -> Cnt trm (PossibleVal trm)
divv (Val v) (Val w) = return (Val (v / w))
divv (Val v) (Exp n) = return (Exp (div (rat v) n))
divv (Exp m) (Val 1) = return (Exp m)
divv (Exp m) (Val w) = return (Exp (div m (rat w)))
divv (Exp m) (Exp n) = return (Exp (div m n))

newtype WEval trm a = WEval {runWEval :: Cnt trm (Eval trm a)}
instance Trm trm => Trm (WEval trm) where
  rat r     = WEval (pure (Val r))
  eql m n   = WEval (join (eqlv <$> (runWEval m) <*> (runWEval n)))
  mul m n   = WEval (join (mulv <$> (runWEval m) <*> (runWEval n)))
  div m n   = WEval (join (divv <$> (runWEval m) <*> (runWEval n)))
  unt       = WEval (pure ())
  abs n     = WEval (pure (\ x -> runWEval (n (WEval (pure x)))))
  app l m   = WEval (join (($) <$> (runWEval l) <*> (runWEval m)))
  prd m n   = WEval ((,)   <$> (runWEval m) <*> (runWEval n))
  pi1 l     = WEval (fst   <$> (runWEval l))
  pi2 l     = WEval (snd   <$> (runWEval l))
  inl m     = WEval (Left  <$> (runWEval m))
  inr n     = WEval (Right <$> (runWEval n))
  cas l m n = WEval (join (caseEither <$> (runWEval l)
                           <*> (runWEval m) <*> (runWEval n)))

type Syn a = forall trm. Trm trm => trm a
type Sem a = forall trm. Trm trm => Cnt trm (Eval trm a)

eval :: Syn a -> Sem a
eval m = runWEval m

-- end
------

-- Reification
--------------
-- begin

reify :: (Typeable a', Trm trm) =>
         Rel 'True trm a a' -> a -> trm a'
reify (CnvT a f) l = reify a (f l)
reify ExpT       l = l
reify OneT       l = unt
reify (ArrT a b) l = abs (\ x -> reset (reify b <$> (join (l <$> (reflect a x)))))
reify (PrdT a b) l = prd (reify a (fst l)) (reify b (snd l))
reify (SumT a b) l = caseEither l (\ x -> inl (reify a x))
                                  (\ y -> inr (reify b y))

reflect :: (Typeable a' , Trm trm) =>
           Rel 'False trm a a' -> trm a' -> Cnt trm a
reflect (CnvF a f) l = f <$> (reflect a l)
reflect ExpT       l = return l
reflect OneT       l = return ()
reflect (ArrT a b) l = return (\ x -> reflect b (app l (reify a x)))
reflect (PrdT a b) l = ((,)) <$> (reflect a (pi1 l)) <*> (reflect b (pi2 l))
reflect (SumT a b) l = shift (\ k -> cas l
                             (abs (\ x -> reset ((k . Left)  <$> (reflect a x))))
                             (abs (\ y -> reset ((k . Right) <$> (reflect b y)))))

-- end
------


-- Normalisation
-----------------
-- begin

class Typeable a => InferRel p a where
  inferRel :: Trm trm => Rel p trm (Eval trm a) a

instance InferRel 'True Rational where
  inferRel = CnvT ExpT (\ x -> case x of
                                 Val v -> rat v
                                 Exp m -> m )

instance InferRel 'False Rational where
  inferRel = CnvF ExpT Exp

instance InferRel p () where
  inferRel = OneT

instance (InferRel (Not p) a , InferRel p b) => InferRel p (a -> b) where
  inferRel = ArrT inferRel inferRel

instance (InferRel p a , InferRel p b) => InferRel p (a , b) where
  inferRel = PrdT inferRel inferRel

instance (InferRel p a , InferRel p b) => InferRel p (Either a b) where
  inferRel = SumT inferRel inferRel

norm :: forall a. InferRel 'True a =>
       (forall trm. Trm trm => trm a) ->
       (forall trm. Trm trm => trm a)
norm m = reset (reify inferRel <$> (eval m))

-- end
------

power :: Integer -> Syn (Rational -> Rational)
power n = abs (\ x ->
  if n < 0       then
    ifT (eql x (rat 0.0))
      (rat 0.0)
      (((rat (-1)) `div` (power (- n) `app` x)))
  else if n == 0 then
    (rat 1)
  else if even n then
    (let  y = power (P.div n  2) `app` x
     in   y `mul` y)
  else
    x `mul` (power (n - 1) `app` x))

power' :: Integer -> Syn (Rational -> MaybeT Rational)
power' n = abs (\ x ->
  if n < 0       then
    ifT (eql x (rat 0.0))
      nothingT
      ((abs (\ y -> (rat (-1)) `div` y))
        <$$> (power' (- n) `app` x))
  else if n == 0 then
    justT (rat 1)
  else if even n then
    ((abs (\ y -> y `mul` y))
      <$$> (power' (P.div n  2) `app` x))
  else
    ((abs (\ y -> x `mul` y))
      <$$> (power' (n - 1) `app` x)))

power'' :: Integer -> Syn (Rational -> Rational)
power'' n = abs (\ x -> maybeT (abs (\ z -> z)) (rat 0) (power' n `app` x))
