function T = calculeazaTransformarea(A,B,C,D,E,F)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    T1 = [C(1)-A(1), B(1)-A(1),A(1);
        C(2)-A(2), B(2)-A(2), A(2);
        0,0,1];
    
    T2 = [F(1)-D(1), E(1)-D(1),D(1);
        F(2)-D(2), E(2)-D(2), D(2);
        0,0,1];
    
    T = T2 * inv(T1);
    
end
