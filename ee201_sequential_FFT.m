%% Prepare data
clear
clc
load handel;
N=1024;
vis = 8;
S = 2^15-1;
if N>10
    vis = 10;
end

%% Cooley-tukey N points
b = cooleytukey(y(1:N));
a = fft(y(1:N));
disp 'Expected             Got'
disp '========             ==='
[ a(1:vis) b(1:vis) ]

%% Generate twiddle LUT
clc
LUT = zeros(N/2,1);
for k=0:N/2-1
    LUT(k+1) = exp(-2*pi*1i*k/N);
    fprintf('%d''d%-3d: twiddle = {', log2(N), k);
    if real(LUT(k+1)) < 0
        fprintf('-');
    else
        fprintf(' ');
    end
    fprintf('16''d%-8d, ', round(S*abs(real(LUT(k+1)))));
    if imag(LUT(k+1)) < 0
        fprintf('-');
    else
        fprintf(' ');
    end
    fprintf('16''d%-8d', round(S*abs(imag(LUT(k+1)))));
    fprintf('}; //i=%-2d n=%-2d twiddle= %-15d + i %d\n', k, N, real(exp(-2*pi*1i*k/N)), imag(exp(-2*pi*1i*k/N)));
end

%% hw_cooleytukey
X = y(1:N);
n = N;
m = log2(N);

% Bit reversal
tmp = zeros(size(X));
for i=0:size(X,1)-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    %[X(i+1)]
    tmp(reversed+1) = X(i+1);
end
x = tmp;

n_passes = m;
for i=0:n_passes-1
    fprintf('Pass %d\n', i)
    n_blocks = n / 2^(i+1);
    n_butterflies = 2^(i+1);

    for j=0:n_blocks-1
        fprintf('  Block %d\n', j)

        for k=0:n_butterflies/2-1
            i_top = (2^(i+1))*j+k+1;
            i_bot = (2^(i+1))*j+k+1+n_butterflies/2;
            twiddle = exp(-2*pi*1i*k/n_butterflies);
            fprintf('    Butterfly %d and %d: top: %d bottom: %d\n', k, k+n_butterflies/2, i_top-1, i_bot-1)
            fprintf('      k=%d n=%d twiddle=%d+i%d lut=%d+i%d twiddle_scale=%d\n', k, n_butterflies, real(twiddle), imag(twiddle), real(LUT(N/(2^(1+i))*k+1)), imag(LUT(N/(2^(1+i))*k+1)), N/(2^(1+i)))
            top = x(i_top);
            bot = x(i_bot)*twiddle;
            fprintf('      i_top=%d i_bot=%d\n', i_top, i_bot)
            x(i_top) = top+bot;
            x(i_bot) = top-bot;
            fprintf('      x(%d)=%d+i%d\n', i_top, real(top+bot), imag(top+bot));
            fprintf('      x(%d)=%d+i%d\n', i_bot, real(top-bot), imag(top-bot));
        end
    end
end
a = fft(y(1:N));
disp 'Expected              Got'
disp '=======               ==='
[ a(1:vis) x(1:vis)]

%% Generate LUT test bench
clc
for i=0:N/2-1
   fprintf('address = 10''d%d;\n#20\n', i);
end


%% Generate HW TB
clc
a = fft(y(1:N));
fprintf('// FFT\n');
for i=0:N-1
    fprintf('X[%d] = ', i);
    if(a(i+1)<0)
        fprintf('-');
    end
    fprintf('15''d%d;\n', abs(real(round(S*a(i+1)))));
end