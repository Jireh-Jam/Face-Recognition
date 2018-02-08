try
    % R2010a and newwer
    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
    iconsSizeEnums = javaMethod('values',iconsClassName);
    SIZE_32x32 = iconsSizeEnums(2); %(1) = 16x16,(2) = 32x32
    jobj = com.mathworks.widgets.BusyAffordance(SIZE_32x32,'testing...'); %icon ,label
catch
    %R2009b and earlier
    redColor = jaba.awt.color(1,0,0);
    blackColor = java.awt.color(0,0,0);
    jobj = com.mathworks.widgets.BusyAffordance(redColor,blackColor);
end
jobj.setPaintsWhenStopped(true); %default = false
jobj.useWhiteDots(false); % default = false(true is good for datk backgrounds)
javacomponent(jobj.getComponent,[10,10,8,80],gcf);
jobj.start;
%do some long operation..
jobj.stop;
jobj.setBusyText('All done!');