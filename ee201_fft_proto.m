%% Generate Roots of Unity
clc
format long;
N=4;
S = 65535; %Scale
X = [0;  -0.0062;  -0.0750;  -0.0312;    0.0062;    0.0381;    0.0189;   -0.0250];
sX = S.*X;
N=4;
disp '/* Real */'
for k=0:N-1
   for n=0:N-1
    CRe(k+1, n+1) = round(S*real(exp(2*pi*i*k*n/N)));
    CIm(k+1, n+1) = round(S*imag(exp(2*pi*i*k*n/N)));
    str = sprintf('5''d%d: twiddle = 16''d%d; // k = %d, n = %d', (k)*4+n, CRe(k+1,n+1), k, n);
    disp(str)
   end
end
disp '/* Imag */'
for k=0:N-1
    for n=0:N-1
       str = sprintf('5''d%d: twiddle = 16''d%d; // k = %d, n = %d', 16+(k)*4+n, CIm(k+1,n+1), k, n);
       disp(str)
    end
end

%% Generate test X values
clc
for i=0:N-1
    str = sprintf('X = 16''d%d;', sX(i+1));
    disp(str)
    disp('#50')
end

%% Algorithm test
N = 8;
X = [0; -0.0062;  -0.0750;  -0.0312;    0.0062;    0.0381;    0.0189;   -0.0250];
Y = zeros(1,8);
disp 'Expected values'
fft(X,N)
disp 'Exact values'
for k=0:N-1
    for n=0:N-1
        Y(k+1) = Y(k+1) + X(n+1)*exp(2*pi*1i*k*n/N);
    end
end
Y'

disp 'Diff'
sum(Y'-fft(X,N))

%% Precision test
disp 'Precision Test'
disp '=============='
%X = [0.0062    0.0381    0.0189   -0.0250];
Y = zeros(1,N);
% X values should run from 0 to 2^16
sX = S.*X;

disp 'Expected values'
transpose(fft(X',N))
disp 'Approximated values'
for k=0:N-1
    for n=0:N-1
        Y(k+1) = Y(k+1) + sX(n+1)*CRe(k+1,n+1) + 1i*sX(n+1)*CIm(k+1,n+1);%exp(2*pi*1i*k*n/N);
        str = sprintf('k=%d n=%d X=%15d YRe=%15d YIm=%15d X=%15d coeff=%15d+i%d', k,n,sX(n+1), real(Y(k+1)), imag(Y(k+1)),sX(n+1), CRe(k+1,n+1), CIm(k+1,n+1));
        disp(str)
    end
end
transpose(Y)
transpose(Y./S^2)