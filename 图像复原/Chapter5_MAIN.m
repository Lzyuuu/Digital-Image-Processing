clc;clear;close all;
% ͼ����븴ԭ
method = 5;
switch method
    case 1
        % ��������һ�������ͼ��ɼ������еĵ���������š�ͨ����ͨ��Ƶ���˲�������ģ���
        % ������������ģ���Ƕ�ά���Ҳ�
        % ����ĳ��������Ƶ�׺Ϳռ���������ģʽ
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
        title('ָ�������Ƶ��');
        subplot(322);
        imshow(r1, [ ]);
        title('��Ӧ����������ģʽ');
        subplot(323);
        imshow(S2, [ ]);
        title('���Ƶ�����');
        subplot(324);
        imshow(r2, [ ]);
        title('��Ӧ����������ģʽ');
        subplot(325);
        imshow(r3, [ ]);
        title('���������ģʽ');
        subplot(326);
        imshow(r4, [ ]);
        title('ʹ���˷�Ĭ�ϵ��������');
        
    case 2
        % ������������
        % ��ȡ��·�����ͼ�񣬼��������Ϊ��˹����
        f = imread('Fig0507(b)(ckt-board-gauss-var-400).tif');
        % ROIPOLY������ѡ��һ������Ȥ����ROI����ɾ����ɾ����ǰѡ�еĶ��㣬Shift��
        % ���ϵ������Ҽ���˫��Ϊѡ��������һ�����㣬Ȼ����1�����������return��
        % ����ѡ����������κζ���
        [B, c1, r] = roipoly(f);     % BΪ��ֵͼ��c��rΪ��������
        % HISTROI Computes the histogram of an ROI in an image
        % ѡ��һ����������ı�����������Ϊ��˹�ͣ����Թ���B��ƽ���Ҷ��൱�ӽ�û������
        % ��ͼ���ƽ���Ҷȣ���Ϊ������ֵΪ�㡣ͬʱ��B���Ŀɱ�����Ҫ�������ı仯��ɡ�
        % ���������ľ�ֵ�ͷ��������һ����֪�Ҷȵĳ�������
        [p, npix] = histroi(f, c1, r);
        X = imnoise2('gaussian', npix, 1, 147, 20);
        figure;
        subplot(221); imshow(f); title('origin image');
        subplot(222); imshow(B); title('ROI');
        subplot(223); bar(p, 1); title('bar of ROI');
        subplot(224); hist(X, 130); axis([0 300 0 140]);
        title('bar of gauss');
        
    case 3
        % �ռ������˲���(�����ڲ�����ͼ�������ڲ�ͬλ��֮��Ĳ����ͼ��)
        % ��ֵ�˲����������С�˲����Ƿ���������ͳ���˲�������ֵ�˲�����medfilt2ʵ��
        % �����С�˲�����ordfilt2ʵ��
        % ���ú���SPFILT����ʵ�ֶ����˲����˲�
        % IMLINCOMB ����������������
        f = imread('Fig0507(a)(ckt-board-orig).tif');
        [M, N] = size(f);
        % ����������Ⱦ
        R1 = imnoise2('salt & pepper', M, N, 0.1, 0);
        c1 = find(R1 == 0);
        gp = f;
        gp(c1) = 0;
        % ����������Ⱦ
        R2 = imnoise2('salt & pepper', M, N, 0, 0.1);
        c2 = find(R2 == 1);
        gs = f;
        gs(c2) = 255;
        % ���˺��������Ϻð취��ʹ��QΪ��ֵ�ķ������˲���
        fp1 = spfilt(gp, 'chmean', 3, 3, 1.5);
        % ��������������QΪ��ֵ�ķ������˲���
        fp2 = spfilt(gs, 'chmean', 3, 3, -1.5);
        % �ֱ��������С�˲���
        fpmax = spfilt(gp, 'max', 3, 3);
        fsmin = spfilt(gs, 'min', 3, 3);
        % PLOT
        figure;
        imshow(f);
        figure;
        subplot(321); imshow(gp); title('��������');
        subplot(322); imshow(gs); title('��������');
        subplot(323); imshow(fp1); title('Q=1.5��3x3�������˲������˺�������');
        subplot(324); imshow(fp2); title('Q=-1.5��3x3�������˲���������������');
        subplot(325); imshow(fpmax); title('3x3����˲������˺�������');
        subplot(326); imshow(fsmin); title('3x3��С�˲���������������');
        
    case 4
        % ����Ӧ�˲�����ʵ��
        % ��ЩӦ���п���ͨ��ʹ���ܹ����ݱ��˲������ͼ����������Ӧ�˲������Ľ������
        % ����ADPMEDIAN��ʵ�ִ��㷨��SMAX��������������Ӧ�˲������ڵĴ�С��
        f = imread('Fig0507(a)(ckt-board-orig).tif');
        g = imnoise(f, 'salt & pepper', 0.25);  % 0.25�Ľ�������
        f1 = medfilt2(g, [7, 7], 'symmetric');
        f2 = adpmedian(g, 7);
        figure;
        subplot(221); imshow(f); title('origin image');
        subplot(222); imshow(g); title('after s&p');
        % 7x7����ֵ�˲����˲�
        subplot(223); imshow(f1); title('mid-filter');
        % Smax = 7������Ӧ��ֵ�˲�
        subplot(224); imshow(f2); title('adaptive-filter');
        
    case 5
        % �˻�������ģ
        % ʹ�ú���IMFILTER��FSPECIAL���Լ��������ɺ�������ģPSF
        % ͼ��ԭ������������һ����Ҫ���˻���ͼ��ģ�����ɳ����ʹ��������߲�����ģ������
        % �ÿռ����Ƶ��ĵ�ͨ�˲�������ģ����һ����Ҫ���˻�ģ������ͼ���ȡʱ��������
        % ����֮��ľ��������˶���������ͼ��ģ�������ǿ���ʹ��fspecial��ͼ��ģ����ģ��
        % PSF = fspecial('motion', len, theta) ����fspecial������PSF����������
        % ������len�����ص�������������ƶ���Ч��������theta�Զ�Ϊ��λ����˳ʱ�뷽���
        % ��ˮƽ�������len��Ĭ��ֵ��9��theta��Ĭ��ֵ��0����ˮƽ����������Ӧ��9�����ص�
        % �ƶ���
        
        % PIXELDUP����ͨ�����ظ������Ŵ�ͼ��
        
        f = checkerboard(8);    % ���԰�ͼ��
        imshow(f);
        
        
        
        
end





