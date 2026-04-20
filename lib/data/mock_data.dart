class MockData {
  static List<Map<String, dynamic>> ponds = [
    // Company 1 (Joao Silva) - 7 ponds
    ...List.generate(7, (i) => {
      'id': '1_$i',
      'name': 'Viveiro C1_${i + 1}',
      'companyId': '1',
      'oxygen': 6.5 + (i % 3) * 0.5,
      'temperature': 27.0 + (i % 2),
      'salinity': 24.0 + i,
      'ph': 7.5 + (i % 5) * 0.1,
      'transparency': 0.4 + (i % 4) * 0.05,
      'aeratorsOn': i % 3,
      'aeratorsTotal': 4,
      'pumpsOn': i % 2,
      'pumpsTotal': 2,
      'hasAlert': i == 0,
      'isFavorite': i < 2,
      'isAutomatic': true,
      'lastUpdate': DateTime.now().toIso8601String(),
      'devices': [],
      'sensors': sensors,
      'actuators': actuators,
    }),
    // Company 2 (Joao Silva) - 4 ponds
    ...List.generate(4, (i) => {
      'id': '2_$i',
      'name': 'Viveiro C2_${i + 1}',
      'companyId': '2',
      'oxygen': 7.0,
      'temperature': 28.0,
      'salinity': 25.0,
      'ph': 7.8,
      'transparency': 0.5,
      'aeratorsOn': 2,
      'aeratorsTotal': 3,
      'pumpsOn': 1,
      'pumpsTotal': 1,
      'hasAlert': false,
      'isFavorite': false,
      'isAutomatic': true,
      'lastUpdate': DateTime.now().toIso8601String(),
      'devices': [],
      'sensors': sensors,
      'actuators': actuators,
    }),
    // Company 3 (Joao Silva) - 0 ponds (Nothing to add here)
    
    // Company 4 (Jose Santos) - 5 ponds
    ...List.generate(5, (i) => {
      'id': '4_$i',
      'name': 'Viveiro C4_${i + 1}',
      'companyId': '4',
      'oxygen': 6.8,
      'temperature': 29.5,
      'salinity': 26.0,
      'ph': 8.0,
      'transparency': 0.45,
      'aeratorsOn': 1,
      'aeratorsTotal': 4,
      'pumpsOn': 0,
      'pumpsTotal': 2,
      'hasAlert': i == 2,
      'isFavorite': i == 0,
      'isAutomatic': false,
      'lastUpdate': DateTime.now().toIso8601String(),
      'devices': [],
      'sensors': sensors,
      'actuators': actuators,
    }),
    // Company 5 (Jose Santos) - 2 ponds
    ...List.generate(2, (i) => {
      'id': '5_$i',
      'name': 'Viveiro C5_${i + 1}',
      'companyId': '5',
      'oxygen': 7.5,
      'temperature': 28.5,
      'salinity': 22.0,
      'ph': 7.2,
      'transparency': 0.6,
      'aeratorsOn': 3,
      'aeratorsTotal': 3,
      'pumpsOn': 1,
      'pumpsTotal': 1,
      'hasAlert': false,
      'isFavorite': true,
      'isAutomatic': true,
      'lastUpdate': DateTime.now().toIso8601String(),
      'devices': [],
      'sensors': sensors,
      'actuators': actuators,
    }),
    // Company 6 (User 3) - 2 ponds
    ...List.generate(2, (i) => {
      'id': '6_$i',
      'name': 'Viveiro C6_${i + 1}',
      'companyId': '6',
      'oxygen': 7.1,
      'temperature': 27.5,
      'salinity': 25.5,
      'ph': 7.6,
      'transparency': 0.5,
      'aeratorsOn': 2,
      'aeratorsTotal': 4,
      'pumpsOn': 1,
      'pumpsTotal': 2,
      'hasAlert': false,
      'isFavorite': false,
      'isAutomatic': true,
      'lastUpdate': DateTime.now().toIso8601String(),
      'devices': [],
      'sensors': sensors,
      'actuators': actuators,
    }),
  ];

  static List<Map<String, dynamic>> devices = [
    {
      'id': '1',
      'name': 'Aerador Estação 1',
      'type': 'Aerador',
      'status': true,
      'lastActive': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      'pondId': '1_0',
      'power': '2.5 kW',
    },
    {
      'id': '2',
      'name': 'Sensor O₂ Premium',
      'type': 'Sensor',
      'status': true,
      'lastActive': DateTime.now().toIso8601String(),
      'pondId': '1_0',
      'battery': '90%',
    },
  ];

  static List<Map<String, dynamic>> users = [
    {
      'id': '1',
      'name': 'Joao Silva',
      'email': 'joao.silva@teste.com',
      'document': '33408456038',
      'token': 'token_joao',
      'totalCompanies': 3,
      'totalPonds': 11,
      'role': 'admin',
    },
    {
      'id': '2',
      'name': 'Jose Santos',
      'email': 'jose.santos@teste.com',
      'document': '37188712034',
      'token': 'token_jose',
      'totalCompanies': 2,
      'totalPonds': 7,
      'role': 'employee',
    },
    {
      'id': '3',
      'name': 'Renato Oliveira',
      'email': 'renato.oliveira@teste.com',
      'document': '30121901041',
      'token': 'token_renato',
      'totalCompanies': 1,
      'totalPonds': 2,
      'role': 'admin',
    },
  ];

  static List<Map<String, dynamic>> companies = [
    {'id': '1', 'name': 'Fazenda Sol Nascente', 'document': 'cnpj01'},
    {'id': '2', 'name': 'Aquicultura Maré Viva', 'document': 'cnpj02'},
    {'id': '3', 'name': 'Consultoria Acqua', 'document': 'cnpj03'},
    {'id': '4', 'name': 'Cooperativa Pescadores', 'document': 'cnpj04'},
    {'id': '5', 'name': 'Estação Experimental', 'document': 'cnpj05'},
    {'id': '6', 'name': 'Empresa Familiar', 'document': 'cnpj06'},
  ];

  static List<Map<String, dynamic>> userCompanies = [
    // Joao Silva (User 1) - Adm of 3
    {'userId': '1', 'companyId': '1', 'role': 'admin', 'joinDate': '2023-01-01T00:00:00'},
    {'userId': '1', 'companyId': '2', 'role': 'admin', 'joinDate': '2023-01-01T00:00:00'},
    {'userId': '1', 'companyId': '3', 'role': 'admin', 'joinDate': '2023-01-01T00:00:00'},

    // Jose Santos (User 2) - 1 Employee, 1 Admin
    {'userId': '2', 'companyId': '4', 'role': 'employee', 'joinDate': '2023-02-01T00:00:00'},
    {'userId': '2', 'companyId': '5', 'role': 'admin', 'joinDate': '2023-02-01T00:00:00'},

    // Renato Oliveira (User 3) - Adm of 1
    {'userId': '3', 'companyId': '6', 'role': 'admin', 'joinDate': '2023-03-01T00:00:00'},
  ];

  static List<Map<String, dynamic>> sensors = [
    {'id': 's1', 'type': 'Oxygen', 'value': 7.2, 'unity': 'mg/L'},
    {'id': 's2', 'type': 'Salinity', 'value': 25.0, 'unity': 'ppt'},
    {'id': 's3', 'type': 'Temperature', 'value': 28.5, 'unity': '°C'},
  ];

  static List<Map<String, dynamic>> actuators = [
    {'id': 'a1', 'type': 'Bomba', 'name': 'Bomba Principal', 'active': true},
    {'id': 'a2', 'type': 'Aerador', 'name': 'Aerador Primário', 'active': false},
  ];

  static int getTotalPondsByCompany(String companyId) {
    return ponds.where((p) => p['companyId'] == companyId).length;
  }
}
