%% Prepare data
clear
clc
load handel;
N=8; 
m = log2(N);
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
clc
tmp = zeros(size(X));
x_re = tmp;
x_im = tmp;
for i=0:size(X,1)-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    %[X(i+1)]
    tmp(reversed+1) = X(i+1);
end
x_re = tmp.*S;

tick = 0;
n_passes = m;
n_blocks = n/2;
n_butterflies = 2;
for i=0:n_passes-1
    fprintf('Pass %d\n', i)
    n_blocks = 2^(m-i-1);
    n_butterflies = 2^(i+1);

    for j=0:n_blocks-1
        fprintf('  Block %d\n', j)

        for k=0:n_butterflies/2-1            
            i_top = (n_butterflies)*j+k+1;
            i_bot = (n_butterflies)*j+k+1+n_butterflies/2;
            twiddle = round(S*LUT((n_blocks)*k+1));
            twiddle_re = real(twiddle);
            twiddle_im = imag(twiddle);
            fprintf('    Butterfly %d and %d: top: %d bottom: %d\n', k, k+n_butterflies/2, i_top-1, i_bot-1)
            fprintf('      k=%d n=%d twiddle=%d+i%d lut=%d+i%d twiddle_scale=%d\n', k, n_butterflies, real(twiddle), imag(twiddle), real(LUT(N/(2^(1+i))*k+1)), imag(LUT(N/(2^(1+i))*k+1)), N/(2^(1+i)))            
            
            ac = floor(x_re(i_bot)*twiddle_re/S);
            bd = floor(x_im(i_bot)*twiddle_im/S);
            ad = floor(x_re(i_bot)*twiddle_im/S);
            bc = floor(x_im(i_bot)*twiddle_re/S);
            
            top_re = x_re(i_top);
            top_im = x_im(i_top);
            bot_re = ac-bd;
            bot_im = ad+bc;

            x_re(i_top) = (top_re)+(bot_re);
            x_im(i_top) = (top_im)+(bot_im);
            x_re(i_bot) = (top_re)-(bot_re);
            x_im(i_bot) = (top_im)-(bot_im);
            
            fprintf('      x_top=%d x_bot=%d\n', x(i_top), x(i_bot));
            fprintf('------top_re=%d top_im=%d\n', top_re, top_im);
            fprintf('------bot_re=%d bot_im=%d\n', bot_re, bot_im);
            %fprintf('      x(%d)=%d+i%d\n', i_top, real(top+bot), imag(top+bot));
            %fprintf('      x(%d)=%d+i%d\n', i_bot, real(top-bot), imag(top-bot));
        end
    end
end
a = fft(y(1:N));
disp 'Expected              Got'
disp '=======               ==='
[ a(1:vis) x_re(1:vis)/S x_im(1:vis)/S]

%x(1:vis)

%% Generate LUT test bench
clc
for i=0:N/2-1
   fprintf('address = 10''d%d;\n#20\n', i);
end


%% Generate HW TB
clc
a = (y(1:N));
for i=0:N-1
    fprintf('X_Re[%d]=', i);
    if(a(i+1)<0)
        fprintf('-');
    end
    fprintf('16''d%d; ', abs(real(round(S*a(i+1)))));
end

%% Generate packed array in fft
clc
fprintf('assign y_re_packed = { ');
for i=0:N-1
    fprintf('x_re[%d]', N-1-i);
    if i==(N-1)
        fprintf('};\n');
    else
        fprintf(', ');
    end
end

fprintf('assign y_im_packed = { ');
for i=0:N-1
    fprintf('x_im[%d]', N-1-i);
    if i==(N-1)
        fprintf('};\n');
    else
        fprintf(', ');
    end
end

%% Generate packed array in TB
clc
fprintf('wire X_Re_Packed = { ');
for i=0:N-1
    fprintf('X_Re[%d]', N-1-i);
    if i==(N-1)
        fprintf('};\n');
    else
        fprintf(', ');
    end
end

fprintf('wire X_Im_Packed = { ');
for i=0:N-1
    fprintf('X_Im[%d]', N-1-i);
    if i==(N-1)
        fprintf('};\n');
    else
        fprintf(', ');
    end
end

%% Generate unpacked array in fft with Bit Reversal
clc
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));

    fprintf('x_re[%d]<=x_re_packed[%d:%d]', i, 16*(reversed+1)-1, reversed*16);
    if i==(N-1)
        fprintf(';\n');
    else
        fprintf('; ');
        if mod(i,128) == 0
           fprintf('\n'); 
        end
    end
end

for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));

    fprintf('x_im[%d]<=x_im_packed[%d:%d]', i, 16*(reversed+1)-1, reversed*16);
    if i==(N-1)
        fprintf(';\n');
    else
        fprintf('; ');
        if mod(i,128) == 0
           fprintf('\n'); 
        end
    end
end