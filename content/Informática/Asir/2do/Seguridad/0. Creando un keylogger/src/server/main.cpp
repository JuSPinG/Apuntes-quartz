#include <cstdio>
#include <winsock2.h>

using namespace std;

class Server{
public:
	WSADATA WSAData;
	SOCKET server, client;
	SOCKADDR_IN serverAddr, clientAddr;
	FILE * log;
	char buffer[1024];

	Server() {

		WSAStartup(MAKEWORD(2,0), &WSAData);
		server = socket(AF_INET, SOCK_STREAM, 0);

		serverAddr.sin_addr.s_addr = INADDR_ANY;
		serverAddr.sin_family = AF_INET;
		serverAddr.sin_port = htons(5555);

		bind(server, (SOCKADDR *)&serverAddr, sizeof(serverAddr));
		listen(server, 0);

		printf("Esperando clientes... \n");
		int clientAddrSize = sizeof(clientAddr);
		if ((client = accept(server, (SOCKADDR *)&clientAddr, &clientAddrSize)) != INVALID_SOCKET) {
			printf("Cliente conectado\n");
		}
	}

	void Recibir() {

		int bytes_recibidos = recv(client, buffer, sizeof(buffer), 0);
		
		if (bytes_recibidos > 0) {
			buffer[bytes_recibidos] = '\0';
			printf("[Cliente]: %s\n", buffer);

			log = fopen("log.txt", "a");
			fputs(buffer, log);
			fclose(log);

		} else if (bytes_recibidos == 0) {
			printf("Conexión cerrada por el cliente.\n");
		} else {
			printf("Error en recv.\n");
		}
	}

	void Enviar() {

		printf("Escribe el mensaje a enviar: ");
		fgets(this->buffer, sizeof(this->buffer), stdin);
		send(client, buffer, sizeof(buffer), 0);
		memset(buffer, 0, sizeof(buffer));
		printf("Mensaje enviado\n");
	}

	void CerrarSocket()	{

		closesocket(client);
		printf("Cliente cerrado\n");
	}
};


int main()
{
	Server *Servidor = new Server();
	while(true)	{
		Servidor->Recibir();
		//Servidor->Enviar();
	}
}