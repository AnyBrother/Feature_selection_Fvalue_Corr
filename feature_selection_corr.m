function [remained_data_corr_del_add,remained_name_corr_del_add,deleted_data_coor_del_add,deleted_name_coor_del_add] = feature_selection_corr(data_x_y, feas_name, threshold, criteria_num, fea_remain, fea_del, mark)
%{
Input:
    data_x_y: 输入的数据,都是double类,最后一列是标签.
    feas_name: 数据对应的列名,是char类.
    threshold: 相关系数临界值,超过则视为相关性强、有冗余.
    criteria_num: 每个准则层的指标数.% criteria_num=[87, 144, 59, 52, 78, 8, 24, 6, 3, 147, 2];
    fea_remain: 要保留的有经济学含义的指标名称cell; % fea_remain = {'(1)资产负债率'};
    fea_del: 要删除的无经济学含义且不相关的指标名称cell; % fea_del = {'微型企业'};
    mark: 数据标识char类,数据集表示,便于区别保存的mat和excel文件.
Output:
    remained_data_corr_del_add: 保留的指标数据.
    remained_name_corr_del_add: 保留的指标名称.
    deleted_data_coor_del_add: 删除的指标数据.
    deleted_name_coor_del_add: 删除的指标名称.
%}
%% 数据传递
og = data_x_y;
%% 准则层断点计算
flag=zeros(length(criteria_num),2);
flag(1,1)=1;
flag(1,2)=criteria_num(1);
for i=1:length(flag)-1
  flag(i+1,1)=flag(i,2)+1;
  flag(i+1,2)=flag(i+1,1)+criteria_num(i+1)-1;
end
%% 准则层内相关系数计算
R=cell(1,size(flag,1));
xflag=cell(1,size(flag,1));
for  i=1:size(flag,1)
    %R{i}=pcor(og(:,flag(i,1):flag(i,2)));
    R{i}=corr(og(:,flag(i,1):flag(i,2)));
    xflag{i}=flag(i,1):1:flag(i,2);
end
%% 指标的F值计算
weiyue=og(find(og(:,end)==1),:);
feiweiyue=og(find(og(:,end)==0),:);
F=F_value(feiweiyue,weiyue);
F=F';
%% 找出相关性F值要删除的指标对应的列索引.
delete=cell(1,size(flag,1));
d=[];
for i=1:size(flag,1)
    [a,b]=find(abs(R{i})>=threshold&abs(R{i})<1);  %相关系数临界点设置为0.75，此处改为0.8可以再试试
    number=zeros(length(a),2);
    number(:,1)=xflag{i}(a)';
    number(:,2)=xflag{i}(b)';
    Ft(:,1)=F(number(:,1));
    Ft(:,2)=F(number(:,2));
    for j=1:length(a)
        if Ft(j,1)>Ft(j,2)
            delete{i}(j)=number(j,2);
            d=[d,number(j,2)];
        else
            delete{i}(j)=number(j,1);
            d=[d,number(j,1)];
        end
    end
    delete{i}=[number,Ft,delete{i}'];
    a=[];
    b=[];
    number=[];
    Ft=[];
end
d=unique(d); 
%% 记录相关性分析删除保留的指标名
deleted_data_coor = og(: , d);
deleted_name_coor = feas_name(: , d);
all_data_num1 = (1: sum(criteria_num));
for i = 1:length(d)
    all_data_num1(all_data_num1==d(i))=[];
end
remained_data_corr = og(: , all_data_num1);
remained_name_corr = feas_name(: , all_data_num1);
%% 删除无用指标
d_del = d;
flag_in_del=zeros(length(fea_del),2);
flag_in_all=zeros(length(fea_del),2);
for i=1:length(fea_del)
    [flag_in_del(i,1),flag_in_del(i,2)]=ismember(fea_del{1,i},deleted_name_coor);
    [flag_in_all(i,1),flag_in_all(i,2)]=ismember(fea_del{1,i},feas_name);
    if ~flag_in_del(i,1) && flag_in_all(i,1)
        % 如果在全指标集，但没在该删除的指标集中,则应该添加
        d_del = [d_del,flag_in_all(i,2)];
    end
end
d_del = sort(d_del,'ascend'); % 从小到大排序
%% 记录相关性分析删除+且无用指标删除，后的指标名
deleted_data_coor_del = og(: , d_del);
deleted_name_coor_del = feas_name(: , d_del);
all_data_num2 = (1: sum(criteria_num));
for i = 1:length(d_del)
    all_data_num2(all_data_num2==d_del(i))=[];
end
remained_data_corr_del = og(: , all_data_num2);
remained_name_corr_del = feas_name(: , all_data_num2);
%% 添加保留有经济学含义的指标
d_del_add = d_del;
flag_in_add=zeros(length(fea_remain),2);
flag_in_all=zeros(length(fea_remain),2);
add_idx = [];
for i=1:length(fea_remain)
    [flag_in_add(i,1),flag_in_add(i,2)]=ismember(fea_remain{1,i},deleted_name_coor_del);
    [flag_in_all(i,1),flag_in_all(i,2)]=ismember(fea_remain{1,i},feas_name);
    if flag_in_add(i,1) && flag_in_all(i,1)
        % 如果在全指标集，且在要删除的指标集中
        add_idx = [add_idx,flag_in_add(i,2)];
        % d_del_add = [d_del_add,flag_in_all(i,2)];
    end
end
d_del_add(:,add_idx) = [];
d_del_add = sort(d_del_add,'ascend'); % 从小到大排序
%% 记录相关性分析删除+且无用指标删除+且添加有意义指标,后的指标名
deleted_data_coor_del_add = og(: , d_del_add);
deleted_name_coor_del_add = feas_name(: , d_del_add);
all_data_num3 = (1: sum(criteria_num));
for i = 1:length(d_del_add)
    all_data_num3(all_data_num3==d_del_add(i))=[];
end
remained_data_corr_del_add = og(: , all_data_num3);
remained_name_corr_del_add = feas_name(: , all_data_num3);
%% 将最终指标遴选结果,保存为excel
% xlswrite('.\data\data_out\2019.09.07.First_FeatureSelection('+string(threshold)+'-'+string(mark)+').xlsx',[deleted_name_coor_del_add;string(deleted_data_coor_del_add)],'删除的指标数据') %删除的指标数据
% xlswrite('.\data\data_out\2019.09.07.First_FeatureSelection('+string(threshold)+'-'+string(mark)+').xlsx',[remained_name_corr_del_add;string(remained_data_corr_del_add)],'保留的指标数据') %保留的指标数据
t=now; time_out = [datestr(t,'yyyy.mm.dd') datestr(t,'.hh：mm.')];
save('.\data\data_out\'+string(time_out)+string(threshold)+'-'+string(mark)+')matlab_vars.mat')
