module sl2_tb;
    // Definir las señales
    logic [31:0] errors;
    logic [63:0] testvectors [2:0];
    logic [63:0] yexpected [2:0];
    logic [63:0] input_a;
    logic [63:0] output_y;

    // Instanciar el módulo
    sl2 #(64) dut (
        .a(input_a),
        .y(output_y)
    );

    // Configurar los vectores de prueba y las expectativas
    initial begin
        // Configurar vectores de prueba
        testvectors[0] = 64'd1;    // Ingresamos 1, debería salir 4
        testvectors[1] = 64'd4;    // Ingresamos 4, debería salir 16
        testvectors[2] = 64'd5;    // Ingresamos 5, debería salir 20
        
        // Configurar expectativas
        yexpected[0] = 64'd4;
        yexpected[1] = 64'd16;
        yexpected[2] = 64'd20;
        
        // Inicializar el contador de errores
        errors = 0;

        // Probar cada vector
        for (int i = 0; i < 3; ++i) begin
            input_a = testvectors[i];
            #10; // Espera para permitir que el módulo procese la entrada

            // Comparar el resultado con la expectativa
            if (output_y !== yexpected[i]) begin
                $display("ERROR: a = %d, Expected y = %d, Actual y = %d", input_a, yexpected[i], output_y);
                errors = errors + 1;
            end
        end
        
        // Mostrar resultados
        if (errors === 0) $display("All tests passed!");
        else $display("Total errors: %d", errors);
        
        $finish; // Terminar la simulación
    end
endmodule
