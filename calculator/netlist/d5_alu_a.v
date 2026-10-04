// Струйный калькулятор — структурный нетлист. Сгенерирован model/gen_netlist.py, вручную не править.
// Каждый экземпляр — один физический элемент (ячейки: netlist/cells/fluidic_cells.v, fluidic_calc.lib).
`timescale 1ms/10us

// АЛУ, дай A: мультиплексор B, дополнение до 9, BCD-сумматор
// Элементов: 120 (AND 53, NOR 2, NOT 1, OR 36, XOR 28)
// Портов: входов 36, выходов 10

module d5_alu_a (
    alu_a0, alu_a1, alu_a2, alu_a3, alu_a4, alu_a5,
    alu_a6, alu_a7, alu_sub, r_reg0, r_reg1, r_reg2,
    r_reg3, r_reg4, r_reg5, r_reg6, r_reg7, run_step,
    sel_x, st_neg, x_reg0, x_reg1, x_reg2, x_reg3,
    x_reg4, x_reg5, x_reg6, x_reg7, y_reg0, y_reg1,
    y_reg2, y_reg3, y_reg4, y_reg5, y_reg6, y_reg7,
    alu_c2, alu_c2_hi, alu_s0, alu_s1, alu_s2, alu_s3,
    alu_s4, alu_s5, alu_s6, alu_s7
);
    input alu_a0;
    input alu_a1;
    input alu_a2;
    input alu_a3;
    input alu_a4;
    input alu_a5;
    input alu_a6;
    input alu_a7;
    input alu_sub;
    input r_reg0;
    input r_reg1;
    input r_reg2;
    input r_reg3;
    input r_reg4;
    input r_reg5;
    input r_reg6;
    input r_reg7;
    input run_step;
    input sel_x;
    input st_neg;
    input x_reg0;
    input x_reg1;
    input x_reg2;
    input x_reg3;
    input x_reg4;
    input x_reg5;
    input x_reg6;
    input x_reg7;
    input y_reg0;
    input y_reg1;
    input y_reg2;
    input y_reg3;
    input y_reg4;
    input y_reg5;
    input y_reg6;
    input y_reg7;
    output alu_c2;
    output alu_c2_hi;
    output alu_s0;
    output alu_s1;
    output alu_s2;
    output alu_s3;
    output alu_s4;
    output alu_s5;
    output alu_s6;
    output alu_s7;

    wire alu_b0, alu_b1, alu_b2, alu_b3, alu_b4, alu_b5, alu_b6, alu_b7;
    wire alu_bc0, alu_bc2, alu_bc3, alu_bc4, alu_bc6, alu_bc7, alu_c1, alu_sub_n;
    wire n_and242, n_and243, n_and245, n_and247, n_and248, n_and250, n_and252, n_and253;
    wire n_and255, n_and257, n_and258, n_and260, n_and262, n_and263, n_and265, n_and267;
    wire n_and268, n_and270, n_and272, n_and273, n_and275, n_and277, n_and278, n_and280;
    wire n_and285, n_and287, n_and293, n_and295, n_and316, n_and317, n_and321, n_and322;
    wire n_and326, n_and327, n_and331, n_and332, n_and335, n_and338, n_and341, n_and342;
    wire n_and347, n_and348, n_and352, n_and353, n_and357, n_and358, n_and362, n_and363;
    wire n_and366, n_and369, n_and372, n_and373, n_nor288, n_nor296, n_or244, n_or249;
    wire n_or254, n_or259, n_or264, n_or269, n_or274, n_or279, n_or282, n_or283;
    wire n_or290, n_or291, n_or318, n_or323, n_or328, n_or333, n_or334, n_or343;
    wire n_or349, n_or354, n_or359, n_or364, n_or365, n_or374, n_xor314, n_xor319;
    wire n_xor320, n_xor324, n_xor325, n_xor329, n_xor330, n_xor339, n_xor345, n_xor350;
    wire n_xor351, n_xor355, n_xor356, n_xor360, n_xor361, n_xor370;

    // ---- 4a Мультиплексор B ----
    AND u_and242 (.A(x_reg0), .B(sel_x), .Y(n_and242));
    AND u_and243 (.A(y_reg0), .B(run_step), .Y(n_and243));
    OR u_or244 (.A(n_and242), .B(n_and243), .Y(n_or244));
    AND u_and245 (.A(r_reg0), .B(st_neg), .Y(n_and245));
    OR u_or246 (.A(n_or244), .B(n_and245), .Y(alu_b0));
    AND u_and247 (.A(x_reg1), .B(sel_x), .Y(n_and247));
    AND u_and248 (.A(y_reg1), .B(run_step), .Y(n_and248));
    OR u_or249 (.A(n_and247), .B(n_and248), .Y(n_or249));
    AND u_and250 (.A(r_reg1), .B(st_neg), .Y(n_and250));
    OR u_or251 (.A(n_or249), .B(n_and250), .Y(alu_b1));
    AND u_and252 (.A(x_reg2), .B(sel_x), .Y(n_and252));
    AND u_and253 (.A(y_reg2), .B(run_step), .Y(n_and253));
    OR u_or254 (.A(n_and252), .B(n_and253), .Y(n_or254));
    AND u_and255 (.A(r_reg2), .B(st_neg), .Y(n_and255));
    OR u_or256 (.A(n_or254), .B(n_and255), .Y(alu_b2));
    AND u_and257 (.A(x_reg3), .B(sel_x), .Y(n_and257));
    AND u_and258 (.A(y_reg3), .B(run_step), .Y(n_and258));
    OR u_or259 (.A(n_and257), .B(n_and258), .Y(n_or259));
    AND u_and260 (.A(r_reg3), .B(st_neg), .Y(n_and260));
    OR u_or261 (.A(n_or259), .B(n_and260), .Y(alu_b3));
    AND u_and262 (.A(x_reg4), .B(sel_x), .Y(n_and262));
    AND u_and263 (.A(y_reg4), .B(run_step), .Y(n_and263));
    OR u_or264 (.A(n_and262), .B(n_and263), .Y(n_or264));
    AND u_and265 (.A(r_reg4), .B(st_neg), .Y(n_and265));
    OR u_or266 (.A(n_or264), .B(n_and265), .Y(alu_b4));
    AND u_and267 (.A(x_reg5), .B(sel_x), .Y(n_and267));
    AND u_and268 (.A(y_reg5), .B(run_step), .Y(n_and268));
    OR u_or269 (.A(n_and267), .B(n_and268), .Y(n_or269));
    AND u_and270 (.A(r_reg5), .B(st_neg), .Y(n_and270));
    OR u_or271 (.A(n_or269), .B(n_and270), .Y(alu_b5));
    AND u_and272 (.A(x_reg6), .B(sel_x), .Y(n_and272));
    AND u_and273 (.A(y_reg6), .B(run_step), .Y(n_and273));
    OR u_or274 (.A(n_and272), .B(n_and273), .Y(n_or274));
    AND u_and275 (.A(r_reg6), .B(st_neg), .Y(n_and275));
    OR u_or276 (.A(n_or274), .B(n_and275), .Y(alu_b6));
    AND u_and277 (.A(x_reg7), .B(sel_x), .Y(n_and277));
    AND u_and278 (.A(y_reg7), .B(run_step), .Y(n_and278));
    OR u_or279 (.A(n_and277), .B(n_and278), .Y(n_or279));
    AND u_and280 (.A(r_reg7), .B(st_neg), .Y(n_and280));
    OR u_or281 (.A(n_or279), .B(n_and280), .Y(alu_b7));

    // ---- 4b Дополнение до 9 ----
    OR u_or282 (.A(alu_b1), .B(alu_b2), .Y(n_or282));
    OR u_or283 (.A(n_or282), .B(alu_b3), .Y(n_or283));
    XOR u_xor284 (.A(alu_b0), .B(alu_sub), .Y(alu_bc0));
    AND u_and285 (.A(alu_b1), .B(alu_sub), .Y(n_and285));
    XOR u_xor286 (.A(alu_b2), .B(n_and285), .Y(alu_bc2));
    AND u_and287 (.A(alu_b3), .B(alu_sub_n), .Y(n_and287));
    NOR u_nor288 (.A(alu_sub_n), .B(n_or283), .Y(n_nor288));
    OR u_or289 (.A(n_and287), .B(n_nor288), .Y(alu_bc3));
    OR u_or290 (.A(alu_b5), .B(alu_b6), .Y(n_or290));
    OR u_or291 (.A(n_or290), .B(alu_b7), .Y(n_or291));
    XOR u_xor292 (.A(alu_b4), .B(alu_sub), .Y(alu_bc4));
    AND u_and293 (.A(alu_b5), .B(alu_sub), .Y(n_and293));
    XOR u_xor294 (.A(alu_b6), .B(n_and293), .Y(alu_bc6));
    AND u_and295 (.A(alu_b7), .B(alu_sub_n), .Y(n_and295));
    NOR u_nor296 (.A(alu_sub_n), .B(n_or291), .Y(n_nor296));
    OR u_or297 (.A(n_and295), .B(n_nor296), .Y(alu_bc7));

    // ---- 4d BCD-сумматор 2 разр. ----
    XOR u_xor314 (.A(alu_a0), .B(alu_bc0), .Y(n_xor314));
    XOR u_xor315 (.A(n_xor314), .B(alu_sub), .Y(alu_s0));
    AND u_and316 (.A(alu_a0), .B(alu_bc0), .Y(n_and316));
    AND u_and317 (.A(n_xor314), .B(alu_sub), .Y(n_and317));
    OR u_or318 (.A(n_and316), .B(n_and317), .Y(n_or318));
    XOR u_xor319 (.A(alu_a1), .B(alu_b1), .Y(n_xor319));
    XOR u_xor320 (.A(n_xor319), .B(n_or318), .Y(n_xor320));
    AND u_and321 (.A(alu_a1), .B(alu_b1), .Y(n_and321));
    AND u_and322 (.A(n_xor319), .B(n_or318), .Y(n_and322));
    OR u_or323 (.A(n_and321), .B(n_and322), .Y(n_or323));
    XOR u_xor324 (.A(alu_a2), .B(alu_bc2), .Y(n_xor324));
    XOR u_xor325 (.A(n_xor324), .B(n_or323), .Y(n_xor325));
    AND u_and326 (.A(alu_a2), .B(alu_bc2), .Y(n_and326));
    AND u_and327 (.A(n_xor324), .B(n_or323), .Y(n_and327));
    OR u_or328 (.A(n_and326), .B(n_and327), .Y(n_or328));
    XOR u_xor329 (.A(alu_a3), .B(alu_bc3), .Y(n_xor329));
    XOR u_xor330 (.A(n_xor329), .B(n_or328), .Y(n_xor330));
    AND u_and331 (.A(alu_a3), .B(alu_bc3), .Y(n_and331));
    AND u_and332 (.A(n_xor329), .B(n_or328), .Y(n_and332));
    OR u_or333 (.A(n_and331), .B(n_and332), .Y(n_or333));
    OR u_or334 (.A(n_xor325), .B(n_xor320), .Y(n_or334));
    AND u_and335 (.A(n_xor330), .B(n_or334), .Y(n_and335));
    OR u_or336 (.A(n_or333), .B(n_and335), .Y(alu_c1));
    XOR u_xor337 (.A(n_xor320), .B(alu_c1), .Y(alu_s1));
    AND u_and338 (.A(n_xor320), .B(alu_c1), .Y(n_and338));
    XOR u_xor339 (.A(n_xor325), .B(alu_c1), .Y(n_xor339));
    XOR u_xor340 (.A(n_xor339), .B(n_and338), .Y(alu_s2));
    AND u_and341 (.A(n_xor325), .B(alu_c1), .Y(n_and341));
    AND u_and342 (.A(n_xor339), .B(n_and338), .Y(n_and342));
    OR u_or343 (.A(n_and341), .B(n_and342), .Y(n_or343));
    XOR u_xor344 (.A(n_xor330), .B(n_or343), .Y(alu_s3));
    XOR u_xor345 (.A(alu_a4), .B(alu_bc4), .Y(n_xor345));
    XOR u_xor346 (.A(n_xor345), .B(alu_c1), .Y(alu_s4));
    AND u_and347 (.A(alu_a4), .B(alu_bc4), .Y(n_and347));
    AND u_and348 (.A(n_xor345), .B(alu_c1), .Y(n_and348));
    OR u_or349 (.A(n_and347), .B(n_and348), .Y(n_or349));
    XOR u_xor350 (.A(alu_a5), .B(alu_b5), .Y(n_xor350));
    XOR u_xor351 (.A(n_xor350), .B(n_or349), .Y(n_xor351));
    AND u_and352 (.A(alu_a5), .B(alu_b5), .Y(n_and352));
    AND u_and353 (.A(n_xor350), .B(n_or349), .Y(n_and353));
    OR u_or354 (.A(n_and352), .B(n_and353), .Y(n_or354));
    XOR u_xor355 (.A(alu_a6), .B(alu_bc6), .Y(n_xor355));
    XOR u_xor356 (.A(n_xor355), .B(n_or354), .Y(n_xor356));
    AND u_and357 (.A(alu_a6), .B(alu_bc6), .Y(n_and357));
    AND u_and358 (.A(n_xor355), .B(n_or354), .Y(n_and358));
    OR u_or359 (.A(n_and357), .B(n_and358), .Y(n_or359));
    XOR u_xor360 (.A(alu_a7), .B(alu_bc7), .Y(n_xor360));
    XOR u_xor361 (.A(n_xor360), .B(n_or359), .Y(n_xor361));
    AND u_and362 (.A(alu_a7), .B(alu_bc7), .Y(n_and362));
    AND u_and363 (.A(n_xor360), .B(n_or359), .Y(n_and363));
    OR u_or364 (.A(n_and362), .B(n_and363), .Y(n_or364));
    OR u_or365 (.A(n_xor356), .B(n_xor351), .Y(n_or365));
    AND u_and366 (.A(n_xor361), .B(n_or365), .Y(n_and366));
    OR u_or367 (.A(n_or364), .B(n_and366), .Y(alu_c2));
    XOR u_xor368 (.A(n_xor351), .B(alu_c2), .Y(alu_s5));
    AND u_and369 (.A(n_xor351), .B(alu_c2), .Y(n_and369));
    XOR u_xor370 (.A(n_xor356), .B(alu_c2), .Y(n_xor370));
    XOR u_xor371 (.A(n_xor370), .B(n_and369), .Y(alu_s6));
    AND u_and372 (.A(n_xor356), .B(alu_c2), .Y(n_and372));
    AND u_and373 (.A(n_xor370), .B(n_and369), .Y(n_and373));
    OR u_or374 (.A(n_and372), .B(n_and373), .Y(n_or374));
    XOR u_xor375 (.A(n_xor361), .B(n_or374), .Y(alu_s7));

    // ---- 4e Инкремент сотен/тысяч ----
    AND u_and376 (.A(alu_c2), .B(alu_sub_n), .Y(alu_c2_hi));

    // ---- 6 Управление ----
    NOT u_nor241 (.A(alu_sub), .Y(alu_sub_n));

endmodule
