function F=F_value(A,B)
%{
该函数仅用于计算F值.
Input:
    A: 非违约;
    B: 违约;
Output:
    F: F值.
%}
total=[A;B]; % 总体矩阵
uA=mean(A); % 非违约每个指标的均值mean(Xj)
uB=mean(B); % 违约每个指标的均值
uT=mean(total);
outdistance=(uA-uT).^2+(uB-uT).^2;
innnerdistance=var(A)+var(B);
F=outdistance./innnerdistance;
end
