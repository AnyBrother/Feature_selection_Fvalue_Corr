# Feature_selection_Fvalue_Corr
This is a Matlab soure code, processing with feature selection with F_value and Correlation_coefficient. Successfully conducted in Matlab_2019b version.

**(In Chinese)** 利用F值和相关系数遴选指标. 在一组相关系数＞threshold(eg. 0.7)的指标中, 剔除F值小的那个指标, 保留F值大的指标. 且是在每个指标准则层内进行的相关系数计算和指标遴选, 保证每个准则层内都有对应指标遴选出. 支持专家主观保留特定指标.

**(In English)** Use the F value and the correlation coefficient to select indicators. In a set of indicators with a correlation coefficient> threshold (eg. 0.7), remove the indicator with the smaller F value, and keep the indicator with the larger F value. This is done within each indicator criterion. The calculation of the correlation coefficient and the selection of indicators ensure that there are corresponding indicators selected in each criterion level. Support experts to subjectively retain specific indicators.

# Program operation instructions

**(In Chinese)**

Step1: 点开“main_F_value.m”

Step2: 放入excel数据：“上市企业全部数据读取.xlsx”和“上市企业_人工定义保留或剔除的指标.xlsx”;

Step3: 设置初始参数(需要人工设置的参数):

```matlab
第10行：index_start = 19;  % 数值型指标开始的列数
第72行：threshold = 0.7;  % 相关系数临界点
第73行：criteria_num=[49, 105, 44, 23, 39, 8, 24, 3, 2, 53, 1];  % 每个二级准则层个数,分准则层指标遴选
```

Step4: 设置完毕，运行即可.

**(In English)**

Step1: open “main_F_value.m” in matlab.

Step2: inout excel data in: “上市企业全部数据读取.xlsx” and “上市企业_人工定义保留或剔除的指标.xlsx”;

Step3: set paramaters (Manually set parameters):

```matlab
Line 10：index_start = 19;  % the first column index for numerical indocator
Line 72：threshold = 0.7;  % threshould for correlation coefficient
Line 73：criteria_num=[49, 105, 44, 23, 39, 8, 24, 3, 2, 53, 1];  % the number of indicators within each indicator criterion
```

Step4: set up, start run it.
