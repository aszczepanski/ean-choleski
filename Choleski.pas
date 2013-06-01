unit Choleski;

interface
  uses
    IntervalArithmetic;
    
  type matrix = Array of Array of Extended;
  type vector = Array of Extended;
  type matrix_ia = Array of Array of interval;
  type vector_ia = Array of interval;
  procedure symposmatrix (n      : Integer;
                        var a  : matrix;
                        b      : vector;
                        var x  : vector;
                        var st : Integer);
  procedure symposmatrix_ia (n      : Integer;
                        var a  : matrix_ia;
                        b      : vector_ia;
                        var x  : vector_ia;
                        var st : Integer);


implementation
       procedure symposmatrix (n      : Integer;
                        var a  : matrix;
                        b      : vector;
                        var x  : vector;
                        var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure symposmatrix solves a system of linear equations with a    }
{  symmetric and positive definite matrix.                                  }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - two-dimensional array containing elements of the matrix of the     }
{        system (the elements a[i,j] for i>=j are changed on exit),         }
{    b - one-dimensional array containing free terms of the system.         }
{  Result:                                                                  }
{    x - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure symposmatrix is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           2, if the matrix of the system is not symmetric,                }
{           3, if the matrix of the system is not positive definite,        }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array x are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k : Integer;
    z     : Extended;
begin
  st:=0;
  if n<1
    then st:=1;
  for i:=2 to n do
    for j:=1 to i-1 do
      if a[i,j]<>a[j,i]
        then st:=2;
  if st=0
    then begin
           i:=0;
           repeat
             i:=i+1;
             for j:=i to n do
               begin
                 z:=a[i,j];
                 for k:=i-1 downto 1 do
                   z:=z-a[j,k]*a[i,k];
                 if i=j
                   then if z>0
                          then a[i,i]:=1/sqrt(z)
                          else st:=3
                   else a[j,i]:=z*a[i,i]
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=1 to n do
                      begin
                        z:=b[i];
                        for j:=i-1 downto 1 do
                          z:=z-a[i,j]*x[j];
                        x[i]:=z*a[i,i]
                      end;
                    for i:=n downto 1 do
                      begin
                        z:=x[i];
                        for j:=i+1 to n do
                          z:=z-a[j,i]*x[j];
                        x[i]:=z*a[i,i]
                      end
                  end
         end
end;

procedure symposmatrix_ia (n      : Integer;
                        var a  : matrix_ia;
                        b      : vector_ia;
                        var x  : vector_ia;
                        var st : Integer);
var i,j,k : Integer;
    z,tmp,a1 : interval;
begin
  a1:=int_read('1');
  st:=0;
  if n<1
    then st:=1;
  for i:=2 to n do
    for j:=1 to i-1 do
      if ((a[i,j].a<>a[j,i].a) or (a[i,j].b<>a[j,i].b))
        then st:=2;
  if st=0
    then begin
           i:=0;
           repeat
             i:=i+1;
             for j:=i to n do
               begin
                 z:=a[i,j];
                 for k:=i-1 downto 1 do
                   z:=(isub(z,imul(a[j,k],a[i,k])));
                 if i=j
                   then if ((z.a>0) and (z.b>0))
                          then begin
                            tmp.a:=sqrt(z.a);
                            tmp.b:=sqrt(z.b);
                            a[i,i]:=idiv(a1,tmp)
                          end
                          else st:=3
                   else a[j,i]:=imul(z,a[i,i])
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=1 to n do
                      begin
                        z:=b[i];
                        for j:=i-1 downto 1 do
                          z:=isub(z,imul(a[i,j],x[j]));
                        x[i]:=imul(z,a[i,i])
                      end;
                    for i:=n downto 1 do
                      begin
                        z:=x[i];
                        for j:=i+1 to n do
                          z:=isub(z,imul(a[j,i],x[j]));
                        x[i]:=imul(z,a[i,i])
                      end
                  end
         end
end;
end.
 