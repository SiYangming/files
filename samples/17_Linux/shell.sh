# 学习前准备，请将data目录复制到C:根目录，或服务器家目录(~/)

# 熟悉工作环境


# 显示当前工作目录 print working directory
pwd 

# cd 切换工作目录
cd /c/12linux
pwd



# 编写一个shell程序 concatenate files and print on the standard output
cat <<END >test.sh
#! /bin/bash
echo 'Hello 易生信!'
END

# 输入如下内容，不包括开头的#和空格，按Ctrl+D结果编辑并保存
# #! /bin/bash
# echo 'Hello 易生信!'

# 让文件变为程序 change file mode bits
chmod +x test.sh

# 运行程序
./test.sh



# 常用命令

# 显示当前文件夹文件 list directory contents
ls # ls是list的缩写
ls -l # 列表显示

# 新建文件夹 make directories 
mkdir -p test # 创建test目录

# 拷贝文件，原文件至目标位置
cp test.sh test/test.txt

# 进入文件夹
cd test

ls # 查看文件夹内容

# 切换至上级目录
cd .. 

# 拷贝文件，原文件至目标位置：cp是copy的缩写
cp test.sh file_temp.txt # 复制文件
cp test.sh test/ # 复制文件到指定目录

# 移动或改名文件:mv是move的缩写
mv test.sh temp.sh # 移动，不更新目录为改名

# 拷贝文件，原文件至目标位置
rm test/test.sh # 文件
rm -r test # 删除文件夹


# 快捷键

# Tab键补全
# cat f # 单选时自动补全
# ls s # 多选时提示侯选

# 中止命令 Ctrl+C
ping -t www.ehbio.com



# fastq文件操作

# 按列表显示文件详细
ls -l example.fq.gz

# 解压缩
gunzip -c example.fq.gz >example.fq

ls -l example.fq

# 显示文件前10行
head example.fq

# 按页查看文件,-S不换行，空格翻页，按q退出，不要按ctrl+d
less -S example.fq

# 转换fastq为fasta，并按顺序重命名序列
awk 'NR%4==2 {print ">E"NR/4+0.5"\n"$0}' example.fq > example.fa

# 显示fasta文件末尾10行
tail example.fa

# 行太长，看不清楚,只显示每行的前50个字符
tail example.fa | cut -b 1-50

# 查找某条序列
grep 'AAAACACAGGAACCTGGGTGAAAAC' example.fa 

# 查找某个名字的序列
grep 'E249.*' example.fa

# 获取对应的序列 -A 1 同时获取匹配行的下一行
grep -A 1 'E249.*' example.fa

# 统计序列条数
grep '>' example.fa | wc -l
grep -c '>' example.fa

# 统计序列长度
grep -v '>' example.fa | awk '{print length($0)}'| head

# 统计序列长度分布
grep -v '>' example.fa | awk '{print length($0)}'|sort|uniq -c



# 查看样品信息表
cat metadata.txt

# 获取所有样品的名字
cut -f 1 metadata.txt

# 获取所有样品名字时跳过第一行
tail -n +2 metadata.txt | cut -f 1

# 对每个样品新建一个文件夹，以样品名字命名
# 传统方式
mkdir -p KO1 KO2 KO3 KO4

# 循环模式
for i in `tail -n +2 metadata.txt | cut -f 1`; do mkdir -p ${i}; done

# 展示for循环中运行了什么

for i in `tail -n +2 metadata.txt | cut -f 1`; do echo "mkdir -p ${i}"; done

# sed替换

# 假如metadata中的Beijing写错了，需要替换为Nanjing
# s: substitute
# /: 分隔符，可以是任意字符，前后统一就行
# s/original/new/: 原始的替换为新的
sed 's/Beijing/Nanjing/' metadata.txt

# awk使用

# 取出metadata.txt的前两列，并把第二列作为输出结果的第一列
# awk擅长于对文件按行操作，每次读取一行，然后进行相应的操作。

#awk读取单个文件时的基本语法格式是awk 'BEGIN{OFS=FS="\t"}{print $0, $1;}' filename。
#读取多个文件时的语法是awk 'BEGIN{OFS=FS="\t"}ARGIND==1{print $0, $1;}ARGIND==2{}' file1 file2。

#awk后面的命令部分是用引号括起来的，可以单引号，可以双引号，但注意不能与内部命令中用到的引号相同，否则会导致最相邻的引号视为一组，引发解释错误。

#OFS: 文件输出时的列分隔符 (output field separtor)

#FS: 文件输入时的列分隔符 (field separtor)

#BEGIN: 设置初始参数，初始化变量

# END: 读完文件后做最终的处理

#其它{}：循环读取文件的每一行,大括号内的命令对每一行都有效，除非有额外判断

# $0表示一行内容；$1, $2, … $NF表示第一列，第二列到最后一列。

# NF (number of fields)文件多少列；NR (number of rows) 文件读了多少行: FNR 当前文件读了多少行，常用于多文件操作时。

# a[$1]=1: 索引操作，类似于python中的字典，在ID map，统计中有很多应用。

awk 'BEGIN{OFS=FS="\t"}{print $2,$1}' metadata.txt

# 计算每个样品的重复的个数

awk 'BEGIN{OFS=FS="\t"}{a[$3]+=1}END{for(i in a) print i,a[i];}' metadata.txt

# 结果多了一行，略过标题行

awk 'BEGIN{OFS=FS="\t"}{if(FNR>1) a[$3]+=1}END{for(i in a) print i,a[i];}' metadata.txt


# 清理临时文件
rm example.fa file_temp.txt temp.sh
for i in `tail -n +2 metadata.txt | cut -f 1`; do rm -rf ${i}; done

# 压缩数据节约空间
gzip example.fq