/**
 * @file ueb01.c
 * Uebung Systemnahe Programmierung im WS 26/27.
 *
 * Ein Programm, das den groessten gemeinsamen Teiler und das kleinste gemeinsame
 * Vielfache zweier ganzer Zahlen berechnet, sowie die n-te Potenz einer Zahl.
 *
 * @author aan, avh, mhe, tti, TODO Hier tragt ihr eure Namen ein
 *
 */

#include <stdio.h>

typedef enum  {
	ERR_NONE = 0,
	ERR_WRONG_PARAMETER_NUMBER = 1,
	ERR_WRONG_OPERANDS = 2,
 	ERR_UNKNOWN_OPERATOR = 3,

} Errorcode;

/**
 * Gibt die Hilfe auf dem uebergebenen Stream (stdout/stderr) aus.
 *
 * @param[in] stream Ausgabestrom
 */
void printUsage (FILE * stream) {
 	// TODO: Implementierung
 	fprintf(stream, "%s",	"Usage:\n\n"
				"  ueb01 -h\n\n"
				"    shows this help and exits.\n\n"
				"  - or -\n\n"
				"  ueb01 NUM1 OP NUM2\n\n"
				"    computes a binary integer operation and prints the result. A call consists\n"
				"    of a number followed by an operation and another number, where:\n\n"
				"    NUM1 and NUM2 have to be positive integer numbers >= 1.\n\n"
				"    OP is one of:\n"
				"      d looks for the greatest common divisor of NUM1 and NUM2\n"
				"      m looks for the least common multiple of NUM1 and NUM2\n"
				"      p calculates the NUM2th power of NUM1\n");
}


/**
* Prueft, ob das übergebene Argument  einer Ganzzahl >= 1 entspricht.
* Das Argument kann einer dezimalen, oktalen oder hexadezimalen Ganzzahl entsprechen.
*
* @param[in]  param Zu überprüfendes Argument
*
* @param[out] number Die zu speichernde Ganzzahl
*/
Errorcode checkNumber(char * arg, int *number) {
	
	Errorcode err = ERR_NONE;
	char ch = ' ';
	if ((sscanf(arg, "%i%c", number, &ch)  != 1)) {
		err = ERR_WRONG_OPERANDS;
	} else if(*number < 1) {
		err = ERR_WRONG_OPERANDS;   
	} 
	return err;
	
}


/**
 * Prueft die Programmparameter auf Korrektheit 
 *
 * @param[in] params Programmparameter
 * @param[out] op1 der erste Operand
 * @param[out] op2 die Operation
 * @param[out] op3 der zweite Operand
 *
 * @return Gibt an, ob ein Fehler aufgetreten ist.
 */
Errorcode checkUsage(int argc, char * params[], int * op1, char * operation, int * op2) {
	
	Errorcode err = ERR_NONE;
	switch(argc) {
		case 0:
		case 1:
		case 3:
			err = ERR_WRONG_PARAMETER_NUMBER;
			break;
		case 2: {
			char ch1 =  ' ', ch2 = ' ', ch3 = ' ';

			if (sscanf(params[1], "%c%c%c", &ch1, &ch2, &ch3) != 2) {
				err = ERR_UNKNOWN_OPERATOR;
			} else if (ch1 != '-' || ch2 != 'h') {
				err = ERR_UNKNOWN_OPERATOR;
			} else {
				*operation = 'h';
			}
			break;
		}
		case 4:{
			char ch = ' ';

			err = checkNumber(params[1], op1);
			
			if (!err) {
				if (sscanf(params[2], "%c%c",  operation, &ch) != 1) {
					err = ERR_UNKNOWN_OPERATOR;
 				} else if(*operation != 'd' && *operation != 'm' && *operation != 'p') {
				 	err = ERR_UNKNOWN_OPERATOR;
				}
			} 

			if (!err) {
				err = checkNumber(params[3], op2);
			}
			break;
		}
		default:
			err = ERR_WRONG_PARAMETER_NUMBER;
	}

	return err;
}

/*
 * Berechnet die n-te Potenz von a
 *
 * @param a Die Basis
 * @param n Der Exponent
 *
 * @retzurn die n-te Potenz von a
 */
long power(int a, int n) {
	
	long result = 1;
	for(int i = 1; i <= n; i++) {
		result*=a;	
	}
	return result;
}


/*
 * Berechnet den größten gemeinsamen Teiler von zwei Ganzzahlen nach dem STEINschen Algorithmus
 *
 * @param a Die erste Zahl
 * @param b Die zweite Zahl
 *
 * @return Der groeßte gemeinsame Teiler von a und b
 * 
 */
int greatestCommonDivisor(int a, int b) {
	
		
	int k = 0;
	while (a%2 == 0 && b%2 == 0) {
		a = a/2;	
		b = b/2;
		k++;	
	}
	int t = a;
	if (a%2 != 0) {
		t = -b;	
	}
	while (t != 0) {
		while(t%2 == 0) {
			t = t/2;		
		}	
		if(t > 0) {
			a = t;		
		} else {
			b = -t;		
		}
		t = a - b;
	}
	return a * power(2,k);

}


/*def ermittlung(Zahl1,Zahl2):
    if Zahl1 != Zahl2:
        multi = 1
        while ((Zahl1 * multi) % Zahl2):
            multi += 1
 
        returnValue = Zahl1 * multi
     
    else:
        returnValue = Zahl1
 
    return returnValue*/

/*
 * Berechnet das kleinste gemeinsame Vielfache von zwei Ganzzahlen 
 *
 * @param a Die erste Zahl
 * @param b Die zweite Zahl
 *
 * @return Das kleinste gemeinsame Vielfache von a und b
 */
int leastCommonMultiple(int a, int b) {
	
	int result = 0;
 
	if (a != b) {
		int multi = 1;
		while((a * multi) % b) {
			multi += 1;	
		}
		result = a * multi;		
	} else {
		result = a;	
	}

	return result;	
}

/**
 * Hauptprogramm.
 * Verarbeitet die Kommandozeilenargumente, prueft diese und fuehrt
 * die angegeben Operationen aus.
 * Im Fehlerfall werden eine Fehlermeldung und die Hilfe ausgegeben.
 *
 * @param[in] argc Anzahl der Programmargumente
 * @param[in] argv Array mit den Programmargumenten
 *
 * @return Fehlercode
 */
int main (int argc, char * argv[]) {

	// TODO: Implementierung
	int op1 = 0, op2 = 0;
	char operation = ' ';
	Errorcode result = checkUsage(argc, argv, &op1, &operation, &op2);  
	switch (result) {
		case ERR_WRONG_PARAMETER_NUMBER:
			fprintf(stderr, "%s\n","Error: Wrong number of parameters.");
			printUsage(stderr);
			break;
		case ERR_WRONG_OPERANDS:
			fprintf(stderr, "%s\n","Error: Numbers must be positive integers.");
			printUsage(stderr);
			break;
		case ERR_UNKNOWN_OPERATOR:
			fprintf(stderr, "%s\n","Error: Unknown operation.");
			printUsage(stderr);
			break;
		default:
			switch (operation) {
				case 'h':
					printUsage(stdout);
					break;
				case 'd':
					fprintf(stdout, "%%%%%%The greatest common divisor of the numbers %u and %u is %u.%%%%%%\n",
						op1, op2,  greatestCommonDivisor(op1,op2));
					break;
				case 'm':
					fprintf(stdout, "\"'*'\"The least common multiple of the numbers %u and %u is %u.\"'*'\"\n",
						op1, op2,  leastCommonMultiple(op1,op2));
					break;
				case 'p':
					fprintf(stdout, "*/^\\*The %uth power of the number %u is %lu.*/^\\*\n",
						op2, op1,  power(op1,op2));
					break;			
			}
	}
	return result;

}
