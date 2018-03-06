clc;clear;close all;
% 图像加噪复原
method = 5;
switch method
    case 1
        % 周期噪声一般产生于图像采集过程中的电气电机干扰。通常是通过频域滤波来处理的，此
        % 处的周期噪声模型是二维正弦波
        % 下面的程序产生的频谱和空间正弦噪声模式
        C1 = [0 64; 0 128; 32 32; 64 0; 128 0; -32 32];
        [r1, R1, S1] = imnoise3(512, 512, C1);
        C2 = [0 32; 0 64; 16 16; 32 0; 64 0; -16 16];
        [r2, R2, S2] = imnoise3(512, 512, C2);
        C3 = [6 32; -2 2];
        A = [1 5];
        [r3, R3, S3] = imnoise3(512, 512, C3);
        [r4, R4, S4] = imnoise3(512, 512, C3, A);
        figure;
        subplot(321);
        imshow(S1, [ ]);
        title('指定冲击的频谱');
        subplot(322);
        imshow(r1, [ ]);
        title('相应的正弦噪声模式');
        subplot(323);
        imshow(S2, [ ]);
        title('相似的序列');
        subplot(324);
        imshow(r2, [ ]);
        title('相应的正弦噪声模式');
        subplot(325);
        imshow(r3, [ ]);
        title('另外的噪声模式');
        subplot(326);
        imshow(r4, [ ]);
        title('使用了非默认的振幅向量');
        
    case 2
        % 估计噪声参数
        % 读取电路板加噪图像，加入的噪声为高斯噪声
        f = imread('Fig0507(b)(ckt-board-gauss-var-400).tif');
        % ROIPOLY函数是选择一个感兴趣区域（ROI），删除键删除先前选中的顶点，Shift键
        % 加上单击、右键、双击为选区添加最后一个顶点，然后用1填充多边形区域，return键
        % 结束选区而不添加任何顶点
        [B, c1, r] = roipoly(f);     % B为二值图像，c、r为列行坐标
        % HISTROI Computes the histogram of an ROI in an image
        % 选择一个几乎不变的背景区，噪声为高斯型，可以估计B区平均灰度相当接近没有噪声
        % 的图像的平均灰度，因为噪声均值为零。同时，B区的可变性主要由噪声的变化造成。
        % 估计噪声的均值和方差可以做一个已知灰度的常量对象
        [p, npix] = histroi(f, c1, r);
        X = imnoise2('gaussian', npix, 1, 147, 20);
        figure;
        subplot(221); imshow(f); title('origin image');
        subplot(222); imshow(B); title('ROI');
        subplot(223); bar(p, 1); title('bar of ROI');
        subplot(224); hist(X, 130); axis([0 300 0 140]);
        title('bar of gauss');
        
    case 3
        % 空间噪声滤波器(适用于不考虑图像特性在不同位置之间的差异的图像)
        % 中值滤波器、最大最小滤波器是非线性排序统计滤波器。中值滤波器用medfilt2实现
        % 最大最小滤波器用ordfilt2实现
        % 采用函数SPFILT函数实现多种滤波器滤波
        % IMLINCOMB 计算输入的线性组合
        f = imread('Fig0507(a)(ckt-board-orig).tif');
        [M, N] = size(f);
        % 胡椒噪声污染
        R1 = imnoise2('salt & pepper', M, N, 0.1, 0);
        c1 = find(R1 == 0);
        gp = f;
        gp(c1) = 0;
        % 盐粒噪声污染
        R2 = imnoise2('salt & pepper', M, N, 0, 0.1);
        c2 = find(R2 == 1);
        gs = f;
        gs(c2) = 255;
        % 过滤胡椒噪声较好办法是使用Q为正值的反调和滤波器
        fp1 = spfilt(gp, 'chmean', 3, 3, 1.5);
        % 盐粒噪声可以用Q为负值的反调和滤波器
        fp2 = spfilt(gs, 'chmean', 3, 3, -1.5);
        % 分别用最大最小滤波器
        fpmax = spfilt(gp, 'max', 3, 3);
        fsmin = spfilt(gs, 'min', 3, 3);
        % PLOT
        figure;
        imshow(f);
        figure;
        subplot(321); imshow(gp); title('胡椒噪声');
        subplot(322); imshow(gs); title('盐粒噪声');
        subplot(323); imshow(fp1); title('Q=1.5的3x3反调和滤波器过滤胡椒噪声');
        subplot(324); imshow(fp2); title('Q=-1.5的3x3反调和滤波器过滤盐粒噪声');
        subplot(325); imshow(fpmax); title('3x3最大滤波器过滤胡椒噪声');
        subplot(326); imshow(fsmin); title('3x3最小滤波器过滤盐粒噪声');
        
    case 4
        % 自适应滤波器的实验
        % 有些应用中可以通过使用能够根据被滤波区域的图像特性自适应滤波器来改进结果。
        % 函数ADPMEDIAN可实现此算法，SMAX是允许的最大自适应滤波器窗口的大小。
        f = imread('Fig0507(a)(ckt-board-orig).tif');
        g = imnoise(f, 'salt & pepper', 0.25);  % 0.25的椒盐噪声
        f1 = medfilt2(g, [7, 7], 'symmetric');
        f2 = adpmedian(g, 7);
        figure;
        subplot(221); imshow(f); title('origin image');
        subplot(222); imshow(g); title('after s&p');
        % 7x7的中值滤波器滤波
        subplot(223); imshow(f1); title('mid-filter');
        % Smax = 7的自适应中值滤波
        subplot(224); imshow(f2); title('adaptive-filter');
        
    case 5
        % 退化函数建模
        % 使用函数IMFILTER和FSPECIAL，以及噪声生成函数来建模PSF
        % 图像复原问题中遇到的一个主要的退化是图像模糊。由场景和传感器两者产生的模糊可以
        % 用空间域或频域的低通滤波器来建模。另一个重要的退化模型是在图像获取时传感器和
        % 场景之间的均匀线性运动而产生的图像模糊。我们可以使用fspecial对图像模糊建模：
        % PSF = fspecial('motion', len, theta) 调用fspecial将返回PSF，它近似于
        % 由有着len个像素的摄像机的线性移动的效果。参数theta以度为单位，以顺时针方向对
        % 正水平轴度量。len的默认值是9，theta的默认值是0，在水平方向上它对应于9个像素的
        % 移动。
        
        % PIXELDUP函数通过像素复制来放大图像
        
        f = checkerboard(8);    % 测试板图像
        imshow(f);
        
        
        
        
end





