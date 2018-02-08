function out = grayworld(img)
%Color Balancing using the Gray World Assumption
%   I - 24 bit RGB Image
%   out - Color Balanced 24-bit RGB Image
%
%   Gaurav Jain, 2010.

    out = uint16(zeros(size(img,1), size(img,2), size(img,3)));
    
    %R,G,B components of the input image
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);

    %Inverse of the Avg values of the R,G,B
    mR = 1/(mean(mean(R)));
    mG = 1/(mean(mean(G)));
    mB = 1/(mean(mean(B)));
    
    %Smallest Avg Value (MAX because we are dealing with the inverses)
    maxRGB = max(max(mR, mG), mB);
    
    %Calculate the scaling factors
    mR = mR/maxRGB;
    mG = mG/maxRGB;
    mB = mB/maxRGB;
   
    %Scale the values
     out(:,:,1) = R*mR;
     out(:,:,2) = G*mG;
     out(:,:,3) = B*mB;
end