function a = clampValue(a, min, max)
a(a<min) = min;
a(a>max) = max;