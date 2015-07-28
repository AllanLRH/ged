clear; close; home

fun = @(x) x(1)^2 + 2.5*sin(x(2)) - x(3)^2*x(1)^2*x(2)^2;

% Initial guesses
initial = [-0.6 -1.2 0.135];
a = fminsearch(fun, initial)
fun(a)

