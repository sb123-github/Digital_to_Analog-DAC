clc
NFFT=2^12; %4096
N1=11;
Fs=(100)*(10^6);
t=0:(NFFT-1);
Fin=(N1/NFFT)*Fs;

%vin=(255/2)*( 1+ sin(2*pi*(Fin/Fs)*t) ); 
%The sine wave is sampled at Fs and made into a digital wave

%vin=sin(2*pi*(Fin/Fs)*t); 

Fin=0.0006;
vin=sin(2*pi*Fin*t); 
plot(t,vin)
%din=quant(vin,2^-7); %the din has numbers rounded off to closest multiples of 2^-7
scaling=2^7 ; 
din=quant(vin,1/scaling)   ;
%din=quant(vin,1);

%figure
%plot(din) %this can plot the sine wave by curve fiting
Din=scaling.*din;
%since all the array elements of din were some multiple of 128(scaling variable) so when we multiplied by 128 
%then all the values were integers with a max sine amplitude of 128
%this is just a basic scaling to 
%increase the amplitude of the Sine to 128(2^7)


Din=scaling + Din; %making the values start from 0 to 256
Din=cast(Din,'uint8'); %the uint8 makes all 256 values go to 255


%Din=typecast(Din,'uint16'); % useless. converts to binary numbers

%figure
%plot(Din) 

disp("Din is ")
Din(1:300)'

bin1=de2bi(Din','right-msb');
disp("bin1 is ")
bin1(1:5,:)
fprintf('Size of bin1 %d %d\n',size(bin1));

bin1=cast(bin1,'double'); 
class(bin1)
bin1(1:5,:)
%fprintf('Size of bin1 %d %d\n',size(bin1));

writematrix(bin1,'binary_matrix.txt','Delimiter','tab');

t_digital=t.*(0.001);
%t_digital=t;
%t_digital=cast(t_digital,'int32');

for i=1:8
    file_name= sprintf('bit%d.txt',i);
    fileID = fopen(file_name,'w');
    temp_arr=[t_digital; bin1(:,i)' ];  
    
    % if I dont do typecasting then the bin1 array remains a uint8 data
    % type and then the t_digital is read as uint8
    
    %also the fprintf functions reads the arrays in columnwise order
    fprintf(fileID,'%.3f %.3f\n',temp_arr);
    fclose(fileID);
    
end

% writematrix(temp_arr,file_name,'Delimiter','tab');
% type 'file_name';




