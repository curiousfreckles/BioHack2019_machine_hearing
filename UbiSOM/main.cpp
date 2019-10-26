
#include "UbiSOM.h"
#include <string>
using namespace std;

#ifdef _DEBUG
#include <crtdbg.h>
#define _CRTDBG_MAP_ALLOC
#endif

int main()
{
	int dataLength = 3,// ����������� ������
		mapHeight = 20, // ���������� � ����� � ����� 
		mapWidth = 20, // ���������� � �������� � ����� 
		minVal = -0.5,// ����������� �������� ��������� ��������
		maxVal = 0.5,// ������������ �������� ��������� ��������, ����� ���������� ����� �������� �����
		topol = UbiSOM::HEXA, // ��� ��������� ( ����� ���� UbiSOM::RECT)
		windowLength=2000,//����� ����
		etaO= 0.1,//��������� ��������  �������� ��������
		 etaF = 0.08,// �������� ��������  �������� ��������
		sigmaO = 0.6, //��������� ��������  ������� ��������� 
		sigmaF = 0.2,//�������� ��������  ������� ��������� 
		beta = 0.7;

	string fileName = "Chain.txt"; // ��� ����� � ������� (���� ������ ��������� � ��� �� ����� ��� � ����������� ���������)
	bool isDataNorm = true; // ������������� �� ������? true - �� false - ���

	UbiSOM *w = new UbiSOM(dataLength,mapHeight,mapWidth,minVal,maxVal,topol,windowLength,etaO,etaF,sigmaO,sigmaF,beta);
	
	w->train(fileName, isDataNorm );
	/*
		���� isDataNorm - true, �� ������ �� �������������
		��� ���� ����� ���������������� � ��� �����������, ��� �� �������

		���� isDataNorm - false, �� ������ ������������� �� max � min ���������.
		��� ���� ��������� ���� � ������ "norm"+fileName,
		����� ���������������� � ��������������� ����������

	*/
	delete w;


	//_CrtMemState _ms;
	//_CrtMemCheckpoint(&_ms);


	/*_CrtMemDumpAllObjectsSince(&_ms);*/

	/*
	_CrtSetReportMode(_CRT_WARN, _CRTDBG_MODE_FILE);
	_CrtSetReportFile(_CRT_WARN, _CRTDBG_FILE_STDOUT);*/

	getchar();
	return 0;
} 


