module adder_tb;

    // Definir señales
    logic [31:0] errors;
    logic [63:0] testvectors_a [2:0];
    logic [63:0] testvectors_b [2:0];
    logic [63:0] yexpected [2:0];
    
    logic [63:0] input_a;
    logic [63:0] input_b;
    logic [63:0] output_y;
    
    // Instanciar el módulo adder
    adder #(64) dut (
        .a(input_a),
        .b(input_b),
        .y(output_y)
    );
    
    // Configurar y ejecutar las pruebas
    initial begin
        // Configurar vectores de prueba
        testvectors_a[0] = 64'd3;
        testvectors_b[0] = 64'd10;
        testvectors_a[1] = 64'd4;
        testvectors_b[1] = 64'd7;
        testvectors_a[2] = 64'd15;
        testvectors_b[2] = 64'd22;
        
        // Configurar expectativas
        yexpected[0] = 64'd13;
        yexpected[1] = 64'd11;
        yexpected[2] = 64'd37;
        
        // Inicializar contador de errores
        errors = 0;
        
        // Probar cada vector
        for (int i = 0; i < 3; i++) begin
            input_a = testvectors_a[i];
            input_b = testvectors_b[i];
            #10; // Esperar para permitir que el módulo procese la entrada

            // Comparar el resultado con la expectativa
            if (output_y !== yexpected[i]) begin
                $display("ERROR:\n  Expected y = %d, Actual y = %d\n  a = %d, b = %d", yexpected[i], output_y, input_a, input_b);
                errors = errors + 1;
            end
        end
        
        // Mostrar resultados
        if (errors === 0) 
            $display("All tests passed!");
        else 
            $display("Total errors: %d", errors);
        
        $finish; // Terminar la simulación
    end

endmodule
