#include <Arduino.h>

// Pines
const int Variador        = 13;  // Salida al relé/variador
const int SensorUno       = 12;  // Sensor de arranque 1
const int SensorDos       = 9;   // Sensor de arranque 2
const int SensorTres      = 10;  // Sensor de arranque 3
const int SensorFinal     = 11;  // Sensor final (detecta con HIGH)
const int Cambiador       = 8;   // Switch de modo (INPUT_PULLUP)
const int paroEmergencia  = 7;   // Botón de paro de emergencia (INPUT_PULLUP)
const int paroEmergencia2 = 6;   // Segundo botón de paro de emergencia

bool inicio = false;  // Estado de partida en MODO 1

// Prototipos
void configuracionesDePines();
boolean verificarParoEmergencia();

void setup() {
  configuracionesDePines();
  digitalWrite(Variador, LOW);
}

void loop() {
  // 1) Paro de emergencia siempre priorizado
  if (verificarParoEmergencia()) return;

  // 2) Modo según Cambiador
  if (digitalRead(Cambiador) == HIGH) {
    // ─── MODO 1 ───
    // Si aún no iniciamos, buscamos cualquiera de los tres sensores
    if (!inicio) {
      if (digitalRead(SensorUno)  == HIGH &&
          digitalRead(SensorDos)  == HIGH &&
          digitalRead(SensorTres) == HIGH) {
        inicio = true;
        digitalWrite(Variador, HIGH);
      }
    }
    // Una vez iniciado, esperamos el sensor final para parar
    else {
      if (digitalRead(SensorFinal) == HIGH) {
        digitalWrite(Variador, LOW);
        inicio = false;
      }
      // si no, mantenemos Variador HIGH
    }
  }
  else {
    // ─── MODO 2 ─── (sin cambios)
    if (digitalRead(SensorFinal) == HIGH) {
      digitalWrite(Variador, LOW);
    } else {
      digitalWrite(Variador, HIGH);
    }
  }

  delay(20);  // debounce ligero
}

void configuracionesDePines() {
  pinMode(SensorUno,      INPUT_PULLUP);
  pinMode(SensorDos,      INPUT_PULLUP);
  pinMode(SensorTres,     INPUT_PULLUP);
  pinMode(SensorFinal,    INPUT_PULLUP);
  pinMode(Cambiador,      INPUT_PULLUP);
  pinMode(paroEmergencia, INPUT_PULLUP);
  pinMode(paroEmergencia2,INPUT_PULLUP);
  pinMode(Variador,       OUTPUT);
}

// Si se presiona cualquier paro, apaga y bloquea hasta soltar.
// Retorna true si el paro se activó (para reiniciar el loop).
boolean verificarParoEmergencia() {
  // HIGH = presionado según tu lógica
  if (digitalRead(paroEmergencia) == HIGH ||
      digitalRead(paroEmergencia2) == HIGH) {
    digitalWrite(Variador, LOW);
    inicio = false;  // Reset de estado
    while (digitalRead(paroEmergencia) == HIGH ||
           digitalRead(paroEmergencia2) == HIGH) {
      delay(10);
    }
    return true;
  }
  return false;
}