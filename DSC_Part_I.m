
clear
close
clc

%% Shahryar Ebrahimi
%% S.N. = 810196093
%% Loading ...

signal   = load('simulateddataset0.mat');
signal   = signal.dataset ;

%% Part a

imshow(signal(:,:,1),[]); title(' first frame of the dataset');

%% Part b

% =========================================================================
% variance Analysis ...

sig_m  = zeros(1,41);
sig_sd = zeros(1,41);

for z = 1:41
    
sig = zeros(1,64*64);

for x = 1:64
	for y = 1:64
            
    	sig(64*(x-1) + y) = signal(x,y,1);
            
	end
end

sig_m(z)   = sum(sig)/length(sig);
sig_sd(z)  = sqrt(var(sig));

end
% =========================================================================

t    = 1:40;
u    = heaviside( t - 8 );   u(8) = 1 ;
Ca   = (( t - 8 ).^ 3) .* exp(-t/1.5) .* u ;

Cvoi = zeros(64,64,40);

mask = signal(:,:,1);
mask ( mask < 100 ) = NaN;
mask ( mask >= 100) = 1;

for i = 1:40
    
    for x = 1:64
        for y = 1:64
    
            if( signal(x,y,1) > 0 && signal(x,y,i+1) > 0 && signal(x,y,1) < 900 && signal(x,y,i+1) < 900 )
            
                Cvoi(x,y,i) =  log(signal(x,y,i+1)/signal(x,y,1));
            
            end
            
        end
    end
    
    Cvoi(:,:,i) = Cvoi(:,:,i) .* mask;
    
end

p   = zeros(1,40);
F   = zeros(64,64);
MTT = zeros(64,64);

for x = 1:64
    for y = 1:64
        
        for i = 1:40   
            p(i) = Cvoi(x,y,i);
        end

        p        = padarray(p, [0 39], 'post');

        R        = @(mtt)     exp(-t/mtt);
        func     = @(f)       norm(p - f(1) .* conv(R(f(2)), Ca), 2)^2;

        [f,fval] = fminsearch(func,[5, 5]);
    
        F(x,y)   = f(1);
        MTT(x,y) = f(2);
        
        clear p
        
    end
end

F   ( F   == 5 ) = NaN;
F   ( abs(F)>1 ) = 0;

MTT ( MTT == 5 )   = NaN;
MTT ( MTT > 100 )  = NaN;

figure, imshow(F,[]);   title('Map of F in Brain');
figure, imshow(MTT,[]); title('Map of MTT in Brain');

