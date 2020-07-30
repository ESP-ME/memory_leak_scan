# 基于jmap的java内存泄露点定位脚本

#### 介绍
基于jmap的java内存泄露点定位脚本

想法来源于Cheat Engine

#### 使用说明
1. 执行脚本，输入要检查的java进程号，脚本自动进行初始化。

2. 初始化完成后，在要测试系统上操作一遍要检测的流程，比较从下订单到支付成功流程。然后选择"1.IncreasedObjectNumber"，就会筛选出增加的实例数。

![输入图片说明](https://images.gitee.com/uploads/images/2020/0730/160515_aa519258_1650820.png "屏幕截图.png")

3. 不进行任何操作，选择"4.Unchanged Object Number"，脚本就会筛选出不变的实例数。

![输入图片说明](https://images.gitee.com/uploads/images/2020/0730/161424_ed3cc815_1650820.png "屏幕截图.png")

4. 多次进行步骤2和步骤3，注意进行步骤2前要操作一次流程进行步骤3前不进行任何操作。

5. 最终筛选只剩下tomcat里session相关的实例在增长，说明这个流程没有内存泄露(其实session相关的实例也可以被筛选调只是要用很长时间)。

![输入图片说明](https://images.gitee.com/uploads/images/2020/0730/161756_655447c0_1650820.png "屏幕截图.png")



