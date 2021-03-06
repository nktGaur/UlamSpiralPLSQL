/* Formatted on 2019-04-17 10:00:42 (QP5 v5.336) */
SET SERVEROUTPUT ON
ACCEPT NUM NUMBER PROMPT 'Please enter the length of matrix you need. Kindly enter an Odd number : ';

DECLARE
    TYPE aat_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;

    TYPE ant_type IS TABLE OF aat_type
        INDEX BY PLS_INTEGER;

    var_aat   ant_type;
    x         NUMBER := 0;
    y         NUMBER := 0;
    v_in      NUMBER := &num;
    v_max     NUMBER := 0;
    l_sql     VARCHAR2 (4000) := NULL;


    PROCEDURE PR_POPULATE (var_in   IN NUMBER,
                           var_x    IN NUMBER,
                           var_y    IN NUMBER)
    IS
        x         NUMBER := var_x;
        y         NUMBER := var_y;
        ylu       NUMBER;
        yld       NUMBER;
        yru       NUMBER;
        yrd       NUMBER;
        xtr       NUMBER;
        xtl       NUMBER;
        xbr       NUMBER;
        xbl       NUMBER;
        ind       NUMBER := var_in;
        var_aat   ant_type;

        FUNCTION is_prime (num NUMBER)
            RETURN BOOLEAN
        IS
            n       NUMBER := num;
            var_l   BOOLEAN := FALSE;
            flag    NUMBER := 1;
        BEGIN
            FOR i IN 2 .. n / 2
            LOOP
                IF MOD (n, i) = 0
                THEN
                    flag := 0;
                    EXIT;
                END IF;
            END LOOP;

            IF flag = 0
            THEN
                var_l := TRUE;
            ELSE
                var_l := FALSE;
            END IF;

            RETURN var_l;
        END is_prime;
    BEGIN
        --POPULATE ORIGIN--
        x := 0;
        y := 0;
        var_aat (x) (y) := 1;

        --POPULATE LEFT--
        FOR i IN 1 .. ind
        LOOP
            var_aat (-i) (y) := 4 * POWER (i, 2) + 2 * i - (i - 1);

            FOR j IN 1 .. i
            LOOP
                ylu := y + j;
                yld := y - j;
                var_aat (-i) (ylu) := var_aat (-i) (ylu - 1) - 1;
                var_aat (-i) (yld) := var_aat (-i) (yld + 1) + 1;
            END LOOP;
        END LOOP;

        --POPULATE RIGHT--
        FOR i IN 1 .. ind
        LOOP
            var_aat (i) (y) := 4 * POWER (i, 2) - 2 * i - (i - 1);

            FOR j IN 1 .. i
            LOOP
                yru := y + j;
                yrd := y - j;
                var_aat (i) (yru) := var_aat (i) (yru - 1) + 1;
                var_aat (i) (yrd) := var_aat (i) (yrd + 1) - 1;
            END LOOP;
        END LOOP;

        --POPULATE TOP--
        FOR i IN 1 .. ind
        LOOP
            var_aat (x) (i) := 4 * POWER (i, 2) - (i - 1);

            FOR j IN 1 .. i
            LOOP
                xtr := x + j;
                xtl := x - j;
                var_aat (xtr) (i) := var_aat (xtr - 1) (i) - 1;
                var_aat (xtl) (i) := var_aat (xtl + 1) (i) + 1;
            END LOOP;
        END LOOP;

        --POPULATE BOTTOM--
        FOR i IN 1 .. ind
        LOOP
            var_aat (x) (-i) := 4 * POWER (i, 2) + 4 * i - (i - 1);

            FOR j IN 1 .. i
            LOOP
                xbr := x + j;
                xbl := x - j;
                var_aat (xbr) (-i) := var_aat (xbr - 1) (-i) + 1;
                var_aat (xbl) (-i) := var_aat (xbl + 1) (-i) - 1;
            END LOOP;
        END LOOP;

        -----PRINTING OUTPUT-------
        /* Debug Purposes */
        --        FOR i IN -ind .. ind
        --        LOOP
        --            l_sql := NULL;
        --            FOR j IN -ind .. ind
        --            LOOP
        --                IF j < ind
        --                THEN
        --                    l_sql := l_sql || '  ' || LPAD (var_aat (i) (j), 4, ' ');
        --                ELSE
        --                    l_sql := l_sql || '  ' || LPAD (var_aat (i) (j), 4, ' ');
        --                    DBMS_OUTPUT.PUT_LINE (l_sql);
        --                END IF;
        --            END LOOP;
        --        END LOOP;

        FOR i IN -ind .. ind
        LOOP
            l_sql := NULL;

            FOR j IN -ind .. ind
            LOOP
                IF j < ind
                THEN
                    l_sql :=
                           l_sql
                        || '  '
                        || LPAD (
                               CASE
                                   WHEN NOT is_prime (var_aat (i) (j))
                                   THEN
                                       '*'
                                   ELSE
                                       ' '
                               END,
                               2,
                               ' ');
                ELSE
                    l_sql :=
                           l_sql
                        || '  '
                        || LPAD (
                               CASE
                                   WHEN NOT is_prime (var_aat (i) (j))
                                   THEN
                                       '*'
                                   ELSE
                                       ' '
                               END,
                               2,
                               ' ');
                    DBMS_OUTPUT.PUT_LINE (l_sql);
                END IF;
            END LOOP;
        END LOOP;
    EXCEPTION
        WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE ('Error occurred in SP!!');
            DBMS_OUTPUT.PUT_LINE (DBMS_UTILITY.FORMAT_ERROR_STACK);
    END PR_POPULATE;
BEGIN
    IF MOD (v_in, 2) = 0
    THEN
        DBMS_OUTPUT.PUT_LINE ('Number is not odd. Exiting.');
    ELSE
        v_max := (v_in - 1) / 2;

        ----POPULATING SPIRAL-----
        pr_populate (var_in => v_max, var_x => x, var_y => y);
    END IF;
END;
