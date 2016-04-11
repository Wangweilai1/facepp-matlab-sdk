x = [37.5, 40.0, 43.3, 46.2, 49.2, 53.7, 58.1, 63.5, 69.4, 75.0, 80.0, 81.3, 82.7, 84.3, 85.0, 84.2, 83.4, 82.1, 80.1];
y = [46.6, 52.1, 56.5, 61.1, 64.9, 68.1, 71.3, 73.5, 74.9, 73.2, 69.6, 65.9, 60.3, 55.5, 49.6, 43.6, 38.3, 32.4, 27.2];
%fun = @(p, x) p(1) * (x + p(2)) .^ (2) + p(3);
%p = lsqcurvefit(fun,[37.7 85.0 10], x, y);
%plot(x, y, '*r', x, fun(p, x), '-b');
p = polyfit(x, y, 3)
x1 = 35:85;
y1 = polyval(p, x1);
plot(x, y, '*r', x1, y1, '-b');