function F=F_value(A,B)
%{
�ú��������ڼ���Fֵ.
Input:
    A: ��ΥԼ;
    B: ΥԼ;
Output:
    F: Fֵ.
%}
total=[A;B]; % �������
uA=mean(A); % ��ΥԼÿ��ָ��ľ�ֵmean(Xj)
uB=mean(B); % ΥԼÿ��ָ��ľ�ֵ
uT=mean(total);
outdistance=(uA-uT).^2+(uB-uT).^2;
innnerdistance=var(A)+var(B);
F=outdistance./innnerdistance;
end
