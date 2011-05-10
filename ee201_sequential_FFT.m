%% Prepare data
clear
clc
load handel;
N=256; 
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

%% Meminit
clc
fprintf('.INIT_00(256''h');
for i=1:256
    num = round(y(i)*S);
    if num<0
        %take compliment 
        num = abs(num);
        show = dec2hex(bitcmp(num,32));
    else
        show = dec2hex(num,8);
    end
    fprintf('%s_', show);
    if(~mod(i,8) && i>1 && i~=256)
        fprintf(';\n');
        fprintf('.INIT_%s(256''h', dec2hex(i/8, 2));
    end
end
fprintf(';\n');

%% hw_cooleytukey
X = y(1:N);
% IFFT Mode
%X = imag(fft(y,1024)) + 1i*real(fft(y,1024));

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
x_re = round(real(tmp.*S));
x_im = round(imag(tmp.*S));

            [[0:7]' [x_re(1); x_re(2); x_re(3); x_re(4); x_re(5); x_re(6); x_re(7); x_re(8)] [x_im(1); x_im(2); x_im(3); x_im(4); x_im(5); x_im(6); x_im(7); x_im(8)]]

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
            fprintf('      x_top(%d) %d+i%d x_bot(%d) %d+i%d\n', i_top, x_re(i_top), x_im(i_top), i_bot, x_re(i_bot), x_im(i_bot));

            ac = round(x_re(i_bot)*twiddle_re);
            bd = round(x_im(i_bot)*twiddle_im);
            ad = round(x_re(i_bot)*twiddle_im);
            bc = round(x_im(i_bot)*twiddle_re);
            
            [ac bd ad bc]
            
            top_re = x_re(i_top);
            top_im = x_im(i_top);
            bot_re = ((ac-bd)/(S-1));
            bot_im = ((ad+bc)/(S-1));
            
            if bot_re < 0
                bot_re = round(bot_re);
            else
                bot_re = fix(bot_re);
            end
            
            if bot_im < 0
                bot_im = round(bot_im);
            else
                bot_im = fix(bot_im);
            end
            
            [top_re top_im bot_re bot_im]
            
            [[0:7]' [x_re(1); x_re(2); x_re(3); x_re(4); x_re(5); x_re(6); x_re(7); x_re(8)] [x_im(1); x_im(2); x_im(3); x_im(4); x_im(5); x_im(6); x_im(7); x_im(8)]]

            x_re(i_top) = (top_re+bot_re);
            x_im(i_top) = (top_im+bot_im);
            x_re(i_bot) = (top_re-bot_re);
            x_im(i_bot) = (top_im-bot_im);  
            
            %fprintf('  --> ac=%d bd=%d ad=%d bc=%d\n', ac, bd, ad, bc);
			%fprintf('    --> top_re %d top_im %d\n', top_re, top_im);
			%fprintf('    --> bot_re %d bot_im %d\n', bot_re, bot_im);
        end
    end
end
a = fft(y(1:N));
disp 'Expected              Got'
disp '=======               ==='
[ a(1:vis) x_re(1:vis)/S x_im(1:vis)/S]
disp 'Hw'
disp '=='
[x_re(1:vis) x_im(1:vis)]
disp 'SSD'
disp '==='
for i=1:vis
    ssd_re(i) = x_re(i);
    if(ssd_re(i) < 0)
        ssd_re(i) = bitcmp(abs(ssd_re(i)), 32);
    end
end
[dec2hex(ssd_re(1:vis))]
%x(1:vis)

%% HW IFFT
c = ifft(a);
d = fft(x_im+1i*x_re);
disp 'Expected              Computed           Got'
disp '========              ========           ==='
[ y(1:vis) imag(d(1:vis)/S/1024) ]

%% Generate LUT test bench
clc
for i=0:N/2-1
   fprintf('address = 10''d%d;\n#20\n', i);
end


%% Generate HW TB
clc
a = (y(1:N));
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    
    fprintf('X_Re[%d]=', reversed);
    if(a(i+1)<0)
        fprintf('-');
    end
    fprintf('32''d%d; ', abs(real(round(S*a(i+1)))));
end
fprintf('\n');
for i=0:N-1
    fprintf('X_Im[%d]=', i);
    if(a(i+1)<0)
        fprintf('-');
    end
    fprintf('32''d%d; ', 0);
end

%% Generate Initial LUT
clc
a = (y(1:N));
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    
    fprintf('10''d%d: ', reversed);
    fprintf('x_re = ');
    if(a(i+1)<0)
        fprintf('-');
    end
    fprintf('32''d%d;\n', abs(real(round(S*a(i+1)))));
end


%% Generate IFFT HW TB
clc
a = fft(y(1:N));
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    
    fprintf('X_Re[%d]=', reversed);
    if(real(a(i+1))<0)
        fprintf('-');
    end
    fprintf('32''d%d; ', abs(real(round(S*a(i+1)))));
end
fprintf('\n');
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));
    
    fprintf('X_Im[%d]=', reversed);
    if(imag(a(i+1))<0)
        fprintf('-');
    end
    fprintf('32''d%d; ', abs(imag(round(S*a(i+1)))));
end

%% Generate unpacked array in fft with Bit Reversal
clc
for i=0:N-1
    inorder = dec2bin(i);
    while size(inorder,2) < m
        inorder = ['0' inorder];
    end
    reversed = bin2dec(fliplr(inorder));

    fprintf('x_re[%d]<=x_re_packed[%d:%d]', i, 32*(reversed+1)-1, reversed*32);
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

    fprintf('x_im[%d]<=x_im_packed[%d:%d]', i, 32*(reversed+1)-1, reversed*32);
    if i==(N-1)
        fprintf(';\n');
    else
        fprintf('; ');
        if mod(i,128) == 0
           fprintf('\n'); 
        end
    end
end