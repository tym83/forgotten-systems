MODULE ArrBench;
(* Счётная нагрузка с ПЛОТНОЙ индексацией массивов.
   Все пределы меньше 4096, значит конфигурация C задействует CHK на каждой индексации.
   Назначение: верхняя граница того, что аппаратная проверка границ вообще может дать.
   Ни одного указателя, ни одного NIL — в отличие от компиляторной нагрузки. *)
  IMPORT Norebo;

  CONST N = 1000; M = 60; R = M*M;   (* R -- размер результата матрицы *)

  VAR a, b: ARRAY N OF INTEGER;
      r: ARRAY R OF INTEGER;   (* был баг: писал в b[i*M+j] до 3599 при N=1000 *)
      m: ARRAY M, M OF INTEGER;

  PROCEDURE Fill;
    VAR i, j: INTEGER;
  BEGIN i := 0;
    WHILE i < N DO a[i] := i * 7 MOD 1021; b[i] := 0; INC(i) END ;
    i := 0;
    WHILE i < M DO j := 0;
      WHILE j < M DO m[i, j] := i + j; INC(j) END ;
      INC(i)
    END
  END Fill;

  (* Пузырьковая сортировка: две индексации на сравнение, четыре на обмен *)
  PROCEDURE Sort;
    VAR i, j, t: INTEGER;
  BEGIN i := 0;
    WHILE i < N DO j := 0;
      WHILE j < N - 1 - i DO
        IF a[j] > a[j+1] THEN t := a[j]; a[j] := a[j+1]; a[j+1] := t END ;
        INC(j)
      END ;
      INC(i)
    END
  END Sort;

  (* Умножение матриц: три индексации на итерацию внутреннего цикла *)
  PROCEDURE MatMul;
    VAR i, j, k, s: INTEGER;
  BEGIN i := 0;
    WHILE i < M DO j := 0;
      WHILE j < M DO s := 0; k := 0;
        WHILE k < M DO s := s + m[i, k] * m[k, j]; INC(k) END ;
        r[i * M + j] := s MOD 30011; INC(j)
      END ;
      INC(i)
    END
  END MatMul;

  PROCEDURE Run*;
  BEGIN Fill; Sort; MatMul
  END Run;

END ArrBench.
