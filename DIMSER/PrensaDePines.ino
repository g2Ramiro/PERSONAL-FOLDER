//SELLADORA
#include <Arduino.h>

const int BUTTON_PIN     = 12; // Botón de activación 1
const int BUTTON2_PIN    = 13; // Botón de activación 2
const int EMERGENCY_PIN  = 11; // Paro de emergencia
const int OUTPUT_PIN     =  7; // Salida (relé, LED, etc.)

bool checkEmergencyStop();
void safeDelay(unsigned long ms);

void setup() {
  Serial.begin(9600);

  pinMode(BUTTON_PIN,    INPUT_PULLUP); // HIGH = no presionado, LOW = presionado
  pinMode(BUTTON2_PIN,   INPUT_PULLUP); // HIGH = no presionado, LOW = presionado
  pinMode(EMERGENCY_PIN, INPUT_PULLUP); // HIGH = no presionado, LOW = presionado
  pinMode(OUTPUT_PIN,    OUTPUT);
  digitalWrite(OUTPUT_PIN, HIGH);       // Salida apagada por defecto (activo LOW)
}

void loop() {
  // Si el primer botón está presionado…
  if (digitalRead(BUTTON_PIN) == LOW) {
    // Comprobar que el segundo botón también esté presionado
    if (digitalRead(BUTTON2_PIN) != LOW) {
      // Si NO está presionado el segundo botón, esperar a que suelten el primero
      while (digitalRead(BUTTON_PIN) == LOW) {
        if (checkEmergencyStop()) {
          return;
        }
        delay(10);
      }
      // Salir para volver a evaluar ambos botones
      return;
    }

    // Ahora SÍ ambos botones están simultáneamente en LOW → activar salida
    digitalWrite(OUTPUT_PIN, LOW);

    // Mantener mientras siga presionado el PRIMER botón…
    while (digitalRead(BUTTON_PIN) == LOW) {
      if (checkEmergencyStop()) {
        return; // checkEmergencyStop ya apagó OUTPUT_PIN si hubo paro
      }
      delay(10);
    }

    // Al soltar el PRIMER botón (o si hay paro), entra safeDelay
    safeDelay(8000);
    digitalWrite(OUTPUT_PIN, HIGH); // Apaga la salida
  }
}

bool checkEmergencyStop() {
  if (digitalRead(EMERGENCY_PIN) == HIGH) {
    // Paro de emergencia: apagar salida inmediatamente
    digitalWrite(OUTPUT_PIN, HIGH);
    // Esperar a que se suelte el botón (vuelva a LOW)
    while (digitalRead(EMERGENCY_PIN) == HIGH) {
      delay(10);
    }
    return true;
  }
  return false;
}

void safeDelay(unsigned long ms) {
  unsigned long start = millis();
  while (millis() - start < ms) {
    if (checkEmergencyStop()) {
      break; // Si hay paro, salir del delay anticipadamente
    }
    delay(10);
  }
}