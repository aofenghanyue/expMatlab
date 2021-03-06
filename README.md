####文件说明

1. ga_mis2tar.m

   使用遗传算法优化mis2tar函数的启动函数，将输入的参量变为$\alpha$，便于优化。

2. mis2tar.m

   输入攻角、侧滑角数组，程序在进行弹道计算后输出最后与目标的偏差

3. Particle.m

   质点类。

   属性：速度、位置、声速、重力加速度。

   方法：

   - 得到两物体之间的距离
   - 得到两物体间的视线角

4. utils函数包，包含常用函数，其中point_to_fun函数将离散点转化为分段函数。

5. @Missile导弹类，继承自质点

   属性：飞行时间、速度、俯仰角、偏航角、攻角、侧滑角、弹道轨迹以及自定义的弹道积分步长、最大/小导引距离、比例导引常数、参考面积、升力阻力特性、推力、质量等。

   方法：获取当前导弹的马赫数、升力、阻力，判断目标是否进入导弹的导引区，计算当前导弹到目标需要的过载、攻角侧滑角，绘制弹道曲线等。

#### 运行说明

1. 工作目录切换到本文件夹
2. 打开`matlab optimization tools`，选择`solver`为`ga`
3. `fitness function` 填入`@ga_mis2tar`。`number of variables`填入需要分几段优化，例如，希望将$\alpha$当作常值去优化，则填1，希望$\alpha$在前5秒取一个值，之后再取一常值，则填入2
4. 在`bounds --> lower`处填写优化$\alpha$的取值下限，`bounds --> upper`处填写优化$\alpha$的取值上限（单位：$^\circ$）
5. 点击`start`开始优化