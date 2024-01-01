stock ItsStripe(itemId) {

    if 1506 <= itemId <= 1510 *then
        return 1;

    return 0;
}
stock GetNameStripe(type) {

    new string[92];

    string = "{FF8C00}Встроена нашивка {ffffff}";

	switch type do {
		case 1..3: f(string, sizeof string, "{FF8C00}Встроена нашивка {ffffff}%i-го {FF8C00}уровня {ffffff}(+%i к защите){FF8C00}.", type, type);
		case 4..6: f(string, sizeof string, "{FF8C00}Встроена нашивка {ffffff}%i-го {FF8C00}уровня {ffffff}(+%i к регенерации){FF8C00}.", type-3, type-3);
		case 7..9: f(string, sizeof string, "{FF8C00}Встроена нашивка {ffffff}%i-го {FF8C00}уровня {ffffff}(+%i к урону){FF8C00}.", type-6, type-6);
		case 10..12: f(string, sizeof string, "{FF8C00}Встроена нашивка {ffffff}%i-го {FF8C00}уровня {ffffff}(+%i к удаче){FF8C00}.", type-9, type-9);
		case 13..15: f(string, sizeof string, "{FF8C00}Встроена нашивка {ffffff}%i-го {FF8C00}уровня {ffffff}(+%i к макс. хп){FF8C00}.", type-12, type-12);
	}

    strcat(string,"\n\n");

    return string;

}
stock GetTypeStripe(value, type) {
    switch type do {
        case 0: {
            switch value do {
                case 1506: return 0;  // защита
                case 1507: return 3;  // регенерация
                case 1508: return 6;  // урон
                case 1509: return 9;  // удача
                case 1510: return 12; // макс. хп
	        }
        }
        case 1: {
            switch value do {
                case 1..3: return value;
                case 4..6: return value-3;
                case 7..9: return value-6;
                case 10..12: return value-9;
                case 13..15: return value-12;
            }
        }
        case 2: {
            switch value do {
                case 1..3: return 1;
                case 4..6: return 2;
                case 7..9: return 3;
                case 10..12: return 4;
                case 13..15: return 5;
            }
        }
    }
    return 0;
}