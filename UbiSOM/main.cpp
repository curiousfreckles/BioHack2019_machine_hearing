
#include "UbiSOM.h"
#include <string>
using namespace std;

#ifdef _DEBUG
#include <crtdbg.h>
#define _CRTDBG_MAP_ALLOC
#endif

int main()
{
	int dataLength = 3,// размерность данных
		mapHeight = 20, // количество с строк в карте 
		mapWidth = 20, // количество с столбцов в карте 
		minVal = -0.5,// минимальное значение координат нейронов
		maxVal = 0.5,// максимальное значение координат нейронов, может поменяться после загрузки файла
		topol = UbiSOM::HEXA, // вид топологии ( может быть UbiSOM::RECT)
		windowLength=2000,//длина окна
		etaO= 0.1,//начальное значение  скорости обучения
		 etaF = 0.08,// конечное значение  скорости обучения
		sigmaO = 0.6, //начальное значение  области соседства 
		sigmaF = 0.2,//конечное значение  области соседства 
		beta = 0.7;

	string fileName = "Chain.txt"; // имя файла с данными (файл должен находится в той же папке что и запускаемая программа)
	bool isDataNorm = true; // нормализованы ли данные? true - да false - нет

	UbiSOM *w = new UbiSOM(dataLength,mapHeight,mapWidth,minVal,maxVal,topol,windowLength,etaO,etaF,sigmaO,sigmaF,beta);
	
	w->train(fileName, isDataNorm );
	/*
		если isDataNorm - true, то данные не нормализуются
		при этом карта инициализируется в тех промежутках, что вы указали

		если isDataNorm - false, то данные нормализуются по max и min значениям.
		при этом создается файл с именем "norm"+fileName,
		карта инициализируется в нормализованном промежутке

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


