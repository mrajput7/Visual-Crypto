clc;   
close all;  
%This code convert color images into gray and do encryption on them, if you want to work on color just remove rgb2gray() and unit8() function.

%ENCRYPTION PORTION
%
%Assigning Images

prompt = 'Into how many part you want image to divide : ';
n = input(prompt);
for w = 1:n
     M{w}=double(rgb2gray(uint8(imread(strcat(num2str(w),'.png')))));  %reading image from same directory where script resides;images are 1.png,2.png..and so on.
end
x = double(rgb2gray(uint8(imread('secret.png'))));      %taking secret image "we used secret.png for this purpose"
y=x;
disp(datestr(now,'HH:MM:SS FFF'));
I{1}=M{1};

for w = 1:n-1
  I{w+1}=mod((I{w}+M{w+1}),256);  
end



for i=1:n
y = mod(y-(i*M{i}),256);
end

%Generating Shares
S{1}= y;
for j = 1:n
    S{1}= mod(S{1} - (((n+1)-j)*I{((n+1)-j)}),256);
end
S{1}=round(mod((S{1}/(n+1)),256));
for j = 1:n
    S{j+1}=(mod((I{((n+1)-j)}+S{j}),256));
    
end

%Using Decryption algorithm in same script to prove proof of concept. One can make seprate decryption and encryption algo. But do not forget to import shares in decryption algorithm. 

%
%DECRYPTION PORTION
%

prompt = 'Do you want to assemble Y/N [Y]: ';
str = input(prompt,'s');
if (str == 'Y') || (str == 'y')

  disp(datestr(now,'HH:MM:SS FFF'));
    for f=1:n
    Q{f} = mod((S{f+1}-S{f}),256);
    end
   
   
    
    E{1}=mod(Q{n},256);
    for w = 2:n
  E{w}=mod((Q{(n+1)-w}-Q{(n+2)-w}),256);  
    end
    
 E{n+1}=S{1};
    
    for f=1:n
    E{n+1} = mod((E{n+1}+S{f+1}),256);
   
    end
end

% First level complete. Starting of second level.

imwrite(uint8(x),'SI.png');
a{1}=E{n+1};
for i=1:n
    a{i+1}=mod(a{i}+(i*E{i}),256);
end

%Plotting visual results to compare. 

for j =1:(3*(n+1))
   if(j<=n)
       subplot(3,n+1,j);imwrite(uint8(M{j}),strcat(num2str(j),'.png')); 
   elseif(j<=(2*n)+1)
       subplot(3,n+1,j);imwrite(uint8(S{j-n}),strcat(num2str(j),'.png'));  
   elseif(j<=(3*(n+1)-1))
       subplot(3,n+1,j);imwrite(uint8(E{(j-1)-2*n}),strcat(num2str(j),'.png'));
   end
end

for j =1:(3*(n+1))
   if(j<=n)
       subplot(3,n+1,j);imshow(uint8(M{j})); 
   elseif(j<=(2*n)+1)
       subplot(3,n+1,j);imshow(uint8(S{j-n}));  
   elseif(j<=(3*(n+1)-1))
       subplot(3,n+1,j);imshow(uint8(E{(j-1)-2*n}));
   end
end

figure;
for i = 1:n+1
    subplot(3,n,i);imshow(uint8(a{i}));
end


% M{1....N} ARE IMAGES WHICH ARE TAKEN
% S{1.....N+1} ARE SECRET SHARES
% E{1.....N} ARE IMAGES WHICH ARE RECONSTRUCTED AND E{N+1} GIVES THE IMAGE WHICH IS SAME AS ANOTHER IN DATABASE WHICH GIVES THE RESULT. 

% IN FUTURE WE CAN CHANGE THE E{N+1} SUCH THAT IT DO NOT HAVE TO BE DIFFERENT THAN OTHERS, WHICH WILL DECREASE THE SUSPICION OF ATTACKER.





