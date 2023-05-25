
clear
close
clc

%% Shahryar Ebrahimi
%% S.N. = 810196093
%% Loading ...

brain   = load('casldata_slice.mat');
brain   = brain.slicedata ;
t       = 0:6:6*72-1;                     % needed for Part b & c

%% Part a

T1      = 0.85;
lambda  = 0.9;
alpha   = 1;

f1      = zeros(64,64,72);
f1_mean = zeros(64,64);


for i = 1:72
    
    label     = brain(:,:,2*i-1);
    cont      = brain(:,:,2*i);
    
    A         = (cont - label)./(2 * alpha *cont);
    
    f1(:,:,i) = (lambda * A) ./ (T1 * (1 - A)) ;  
    f1_mean   = f1_mean + f1(:,:,i);
    
end

f1_mean  = f1_mean / 72 ;

figure, imshow(f1_mean,[]);   title(' Averaged MAP of F');

%% Part b

hlp  = zeros(1,72);

for i = 1:72    
    hlp(i) = f1(26,16,i);  
end

figure, plot(t,hlp); title(' F plotted for coordinates of [26 16]');            xlabel('Time (s)'); ylabel('flue (F)');
figure, plot(t,hlp); title(' F plotted for coordinates of [26 16] & [45 25]');  xlabel('Time (s)'); ylabel('flue (F)'); hold on;

for i = 1:72   
    hlp(i) = f1(45,25,i); 
end

plot(t,hlp,'r'); legend('[26 16]','[45 25]'); hold off ;
figure, plot(t,hlp); title(' F plotted for coordinates of [45 25]');  xlabel('Time (s)'); ylabel('flue (F)');


%% Part c

stimulus = ones(1,72);     stimulus(1, 13:2*12) = 0;    stimulus(1, 3*12+1:4*12) = 0;    stimulus(1, 5*12+1:6*12) = 0; 

COR      = zeros(64,64);
hlp      = zeros(1,72);

for x = 1:64
    for y = 1:64
        
        for i = 1:72
            hlp(i) = f1(x,y,i);
        end
        
        COR(x,y)  = corr(hlp', stimulus');

    end
end

figure, imshow(COR,[]);  title(' Correlations of Stimulus versue F');

%% Part d

thr = 0.6 ;      % activation threshold - (1-thr) percent of maximum correlation between stimulus and f

brain_mean  = zeros(64,64);

for i = 1:144
    
    brain_mean  = brain_mean + brain(:,:,i);
    
end

brain_mean  = brain_mean/144;
brain_mean  = brain_mean - min(min(brain_mean));
brain_mean  = brain_mean / max(max(brain_mean));

R           = brain_mean;
G           = brain_mean;
B           = brain_mean;

COR_h = COR;

COR_h  = COR_h - min(min(COR_h));
COR_h  = 2*(COR_h / max(max(COR_h)));
COR_h  = COR_h - 1 ;


G ( COR_h > thr * max(max(COR_h)) ) = 1-COR_h( COR_h > thr * max(max(COR_h)) );
B ( COR_h > thr * max(max(COR_h)) ) = 1-COR_h( COR_h > thr * max(max(COR_h)) );

R ( COR_h < thr * min(min(COR_h)) ) = 1+COR_h( COR_h < thr * min(min(COR_h)) );
G ( COR_h < thr * min(min(COR_h)) ) = 1+COR_h( COR_h < thr * min(min(COR_h)) );

brain_act   = cat(3, R, G, B);

figure, imshow(brain_act);  title('Regions Correlated with Stimulus - RED : Regions upper than 60% of max positive correlation - Blue : Regions upper than 60% of max negative correlation ');
