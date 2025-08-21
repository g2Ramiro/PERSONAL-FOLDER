const int SENSOR1_PIN    =12;   // Sensor de arranque (SensorUno)
const int SENSOR2_PIN    = 13;   // Sensor de final de banda (SensorDos)
const int ESTOP_PIN      =11;   // Paro de emergencia (NC)
const int RELAY_PIN      = 7;  // Salida al módulo de relés VFD

bool motorEnganchado = false;

void setup() {
  pinMode(SENSOR1_PIN, INPUT_PULLUP);
  pinMode(SENSOR2_PIN, INPUT_PULLUP);
  // Paro NC: leerá LOW cuando no esté presionado, HIGH cuando se presione
  pinMode(ESTOP_PIN,   INPUT_PULLUP);

  pinMode(RELAY_PIN,   OUTPUT);
  digitalWrite(RELAY_PIN, LOW); // Motor detenido al iniciar
}

void loop() {
  //Comprobar paro de emergencia
  //    Ahora HIGH = presionado (EMERGENCIA), LOW = normal
  if (digitalRead(ESTOP_PIN) == HIGH) {
    // Emergencia activa: detener y desenclavar
    motorEnganchado = false;
    digitalWrite(RELAY_PIN, LOW);
    // Esperar a que sueltes el paro (vuelva a LOW)
    while (digitalRead(ESTOP_PIN) == HIGH) {
      delay(10);
    }
    // Reiniciar ciclo
    return;
  }

  //Arranque con Sensor1
  if (!motorEnganchado && digitalRead(SENSOR1_PIN) == HIGH) {
    motorEnganchado = true;
    digitalWrite(RELAY_PIN, HIGH);
  }

  //Parada con Sensor2
  if (motorEnganchado && digitalRead(SENSOR2_PIN) == HIGH) {
    motorEnganchado = false;
    digitalWrite(RELAY_PIN, LOW);
    delay(100); // anti-rebote
  }
}