function [remained_data_corr_del_add,remained_name_corr_del_add,deleted_data_coor_del_add,deleted_name_coor_del_add] = feature_selection_corr(data_x_y, feas_name, threshold, criteria_num, fea_remain, fea_del, mark)
%{
Input:
    data_x_y: ���������,����double��,���һ���Ǳ�ǩ.
    feas_name: ���ݶ�Ӧ������,��char��.
    threshold: ���ϵ���ٽ�ֵ,��������Ϊ�����ǿ��������.
    criteria_num: ÿ��׼����ָ����.% criteria_num=[87, 144, 59, 52, 78, 8, 24, 6, 3, 147, 2];
    fea_remain: Ҫ�������о���ѧ�����ָ������cell; % fea_remain = {'(1)�ʲ���ծ��'};
    fea_del: Ҫɾ�����޾���ѧ�����Ҳ���ص�ָ������cell; % fea_del = {'΢����ҵ'};
    mark: ���ݱ�ʶchar��,���ݼ���ʾ,�������𱣴��mat��excel�ļ�.
Output:
    remained_data_corr_del_add: ������ָ������.
    remained_name_corr_del_add: ������ָ������.
    deleted_data_coor_del_add: ɾ����ָ������.
    deleted_name_coor_del_add: ɾ����ָ������.
%}
%% ���ݴ���
og = data_x_y;
%% ׼���ϵ����
flag=zeros(length(criteria_num),2);
flag(1,1)=1;
flag(1,2)=criteria_num(1);
for i=1:length(flag)-1
  flag(i+1,1)=flag(i,2)+1;
  flag(i+1,2)=flag(i+1,1)+criteria_num(i+1)-1;
end
%% ׼��������ϵ������
R=cell(1,size(flag,1));
xflag=cell(1,size(flag,1));
for  i=1:size(flag,1)
    %R{i}=pcor(og(:,flag(i,1):flag(i,2)));
    R{i}=corr(og(:,flag(i,1):flag(i,2)));
    xflag{i}=flag(i,1):1:flag(i,2);
end
%% ָ���Fֵ����
weiyue=og(find(og(:,end)==1),:);
feiweiyue=og(find(og(:,end)==0),:);
F=F_value(feiweiyue,weiyue);
F=F';
%% �ҳ������FֵҪɾ����ָ���Ӧ��������.
delete=cell(1,size(flag,1));
d=[];
for i=1:size(flag,1)
    [a,b]=find(abs(R{i})>=threshold&abs(R{i})<1);  %���ϵ���ٽ������Ϊ0.75���˴���Ϊ0.8����������
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
%% ��¼����Է���ɾ��������ָ����
deleted_data_coor = og(: , d);
deleted_name_coor = feas_name(: , d);
all_data_num1 = (1: sum(criteria_num));
for i = 1:length(d)
    all_data_num1(all_data_num1==d(i))=[];
end
remained_data_corr = og(: , all_data_num1);
remained_name_corr = feas_name(: , all_data_num1);
%% ɾ������ָ��
d_del = d;
flag_in_del=zeros(length(fea_del),2);
flag_in_all=zeros(length(fea_del),2);
for i=1:length(fea_del)
    [flag_in_del(i,1),flag_in_del(i,2)]=ismember(fea_del{1,i},deleted_name_coor);
    [flag_in_all(i,1),flag_in_all(i,2)]=ismember(fea_del{1,i},feas_name);
    if ~flag_in_del(i,1) && flag_in_all(i,1)
        % �����ȫָ�꼯����û�ڸ�ɾ����ָ�꼯��,��Ӧ�����
        d_del = [d_del,flag_in_all(i,2)];
    end
end
d_del = sort(d_del,'ascend'); % ��С��������
%% ��¼����Է���ɾ��+������ָ��ɾ�������ָ����
deleted_data_coor_del = og(: , d_del);
deleted_name_coor_del = feas_name(: , d_del);
all_data_num2 = (1: sum(criteria_num));
for i = 1:length(d_del)
    all_data_num2(all_data_num2==d_del(i))=[];
end
remained_data_corr_del = og(: , all_data_num2);
remained_name_corr_del = feas_name(: , all_data_num2);
%% ��ӱ����о���ѧ�����ָ��
d_del_add = d_del;
flag_in_add=zeros(length(fea_remain),2);
flag_in_all=zeros(length(fea_remain),2);
add_idx = [];
for i=1:length(fea_remain)
    [flag_in_add(i,1),flag_in_add(i,2)]=ismember(fea_remain{1,i},deleted_name_coor_del);
    [flag_in_all(i,1),flag_in_all(i,2)]=ismember(fea_remain{1,i},feas_name);
    if flag_in_add(i,1) && flag_in_all(i,1)
        % �����ȫָ�꼯������Ҫɾ����ָ�꼯��
        add_idx = [add_idx,flag_in_add(i,2)];
        % d_del_add = [d_del_add,flag_in_all(i,2)];
    end
end
d_del_add(:,add_idx) = [];
d_del_add = sort(d_del_add,'ascend'); % ��С��������
%% ��¼����Է���ɾ��+������ָ��ɾ��+�����������ָ��,���ָ����
deleted_data_coor_del_add = og(: , d_del_add);
deleted_name_coor_del_add = feas_name(: , d_del_add);
all_data_num3 = (1: sum(criteria_num));
for i = 1:length(d_del_add)
    all_data_num3(all_data_num3==d_del_add(i))=[];
end
remained_data_corr_del_add = og(: , all_data_num3);
remained_name_corr_del_add = feas_name(: , all_data_num3);
%% ������ָ����ѡ���,����Ϊexcel
% xlswrite('.\data\data_out\2019.09.07.First_FeatureSelection('+string(threshold)+'-'+string(mark)+').xlsx',[deleted_name_coor_del_add;string(deleted_data_coor_del_add)],'ɾ����ָ������') %ɾ����ָ������
% xlswrite('.\data\data_out\2019.09.07.First_FeatureSelection('+string(threshold)+'-'+string(mark)+').xlsx',[remained_name_corr_del_add;string(remained_data_corr_del_add)],'������ָ������') %������ָ������
t=now; time_out = [datestr(t,'yyyy.mm.dd') datestr(t,'.hh��mm.')];
save('.\data\data_out\'+string(time_out)+string(threshold)+'-'+string(mark)+')matlab_vars.mat')
