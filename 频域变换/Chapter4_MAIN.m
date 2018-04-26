clc;clear;close all;
% 
method = 2;
switch method
    case 1
        % ���ӻ���άDFT
        image_rectangle = imread('Fig0424(a)(rectangle).tif');
        fft_rectangle = fft2(image_rectangle);      % ����ҶƵ��
        out_rectangle = abs(fft_rectangle);
        out_rectangle_mid = fftshift(fft_rectangle);    % ����Ƶ��
        out_rectangle_log = log(1 + abs(out_rectangle_mid));
        % ��Ƶ��ʹ�ö����任�����Ӿ���ǿ
        figure;
        subplot(221);
        imshow(image_rectangle);
        title('ԭͼ');
        subplot(222);
        imshow(out_rectangle, [ ]);
        title('FFT֮���ͼ��');
        subplot(223);
        imshow(abs(out_rectangle_mid), [ ]);
        title('���к��ͼ��');
        subplot(224);
        imshow(out_rectangle_log, [ ]);
        title('������ǿ���ͼ��');
        
    case 2
        % ��ȡ����ͼ������Ҷ�任
        image_house = imread('Fig0438(a)(bld_600by600).tif');
        fft_house = fft2(image_house);
        out_house_1 = fftshift(log(1 + abs(fft_house)));    % Ƶ�׾���
        out_house_2 = gscale(out_house_1);  % ��ͼ������ȫ�߶�
        figure;
        subplot(121);
        imshow(image_house);
        title('ԭͼ');
        subplot(122);
        imshow(out_house_2);
        title('����ҶƵ��');
        filter_house_s = fspecial('sobel');     % Create predefined 2-D filter
        PQ_house = paddedsize(size(image_house));   % ���������
        % ��Ƶ����Ӧ
        filter_house_soble = freqz2(filter_house_s, PQ_house(1), PQ_house(2));
        filter_house_f = ifftshift(filter_house_soble);
        figure;
        subplot(121);
        imshow(abs(filter_house_soble), [ ]);
        title('soble��ģ��Ƶ���˲�������ֵ');
        subplot(122);
        imshow(abs(filter_house_f), [ ]);
        title('fftshift���ͬһ�˲���');
        % �ռ����˲�
        out_house_s = imfilter(double(image_house), filter_house_s);
        % Ƶ���˲�
        out_house_f = dftfilt(image_house, filter_house_f);
        figure;
        subplot(321);
        imshow(out_house_s, [ ]);
        title('�ռ���ʹ�ô�ֱSoble��ģ�˲����');
        subplot(322);
        imshow(out_house_f, [ ]);
        title('Ƶ���˲����');
        subplot(323);
        imshow(abs(out_house_s), [ ]);
        title('����ֵ');
        subplot(324);
        imshow(abs(out_house_f), [ ]);
        title('����ֵ');
        subplot(325);
        imshow(abs(out_house_s) > 0.2*abs(max(out_house_s(:))));
        title('��ֵ�����ı�Եͼ��');
        subplot(326);
        imshow(abs(out_house_f) > 0.2*abs(max(out_house_f(:))));              
        title('��ֵ�����ı�Եͼ��');
        
    case 3
        % ��ͨ�˲�ͼ��
        image_a_lp = imread('Fig0441(a)(characters_test_pattern).tif');
        PQ_a = paddedsize(size(image_a_lp));   % ��������
        [U_a, V_a] = dftuv(PQ_a(1),PQ_a(2));    
        % �ṩ������㼰��������Ӧ������Ҫ����������
        % ��dftuv���ɵ���������������fft2��ifft2�Ĵ������Ҫ
        D0_a = 0.05*PQ_a(2);    % ʹ�õ�D0ֵ���������ͼ���ȵ�5%
        F_a = fft2(image_a_lp, PQ_a(1), PQ_a(2));   % ���ͼ��
        H_a = exp(-(U_a.^2 + V_a.^2)/(2*(D0_a^2))); % �˲�����Ӧ
        g_a = dftfilt(image_a_lp, H_a);     % Ƶ���˲�
        figure;
        subplot(121);
        imshow(image_a_lp, [ ]);
        title('ԭͼ');
        subplot(122);
        imshow(g_a, [ ]);
        title('��ͨ�˲����ģ��ͼ��');
        
    case 4
        % ��ͨ�˲�ͼ��
        image_a_hp = imread('Fig0441(a)(characters_test_pattern).tif');
        PQ_a_1 = paddedsize(size(image_a_hp));
        D0_a_1 = 0.05*PQ_a_1(1);
        H_a_1 = hpfilter('gaussian', PQ_a_1(1), PQ_a_1(2), D0_a_1);
        g_a_1 = dftfilt(image_a_hp, H_a_1);
        figure;
        subplot(121);
        imshow(image_a_hp, [ ]);
        title('ԭͼ');
        subplot(122);
        imshow(g_a_1, [ ]);
        title('��ͨ�˲������ͼ��');
        
    case 5
        % ����Ŀ������ͼ��f������X��ͼ�������ѧ͸��һ���۽������Խ��ģ����
        % �������ͼ��ĻҶ�ƫ���ڻҶȼ��İ��ˣ����Ի��������������˵�����ʹ��
        % �ռ�����������Ƶ���˲���
        % ��ȡһ���ز���X��ͼ��f
        f = imread('Fig0459(a)(orig_chest_xray).tif');
        PQ = paddedsize(size(f));
        D0 = 0.05*PQ(1);    % D0��ֵ���������ͼ��ֱ�ߴ��5%
        HBW = hpfilter('btw', PQ(1), PQ(2), D0, 2); % ��ͨ�˲�
        H = 0.5 + 2*HBW;
        gbw = dftfilt(f, HBW);  % Ƶ���ͨ�˲�
        gbw = gscale(gbw);
        ghf = dftfilt(f, H);    % ��Ƶǿ���˲�
        ghf = gscale(ghf);
        ghe = histeq(ghf, 256); % ֱ��ͼ����
        figure;
        subplot(221);
        imshow(f);
        title('ԭͼ');
        subplot(222);
        imshow(gbw);
        title('��Ƶ�˲���');
        subplot(223);
        imshow(ghf);
        title('��Ƶǿ���˲���');
        subplot(224);
        imshow(ghe);
        title('ֱ��ͼ�����');
end







