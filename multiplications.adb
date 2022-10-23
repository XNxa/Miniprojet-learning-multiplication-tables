--------------------------------------------------------------------------------
--  Auteur   : Xavier Naxara 1SN Groupe H 
--  Objectif : Miniprojet PIM
--------------------------------------------------------------------------------

with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO; 
with Ada.Calendar;          use Ada.Calendar;
with Ada.Numerics.Discrete_Random;

--Miniprojet : Programme permettant à un utilisateur de réviser les tables de multiplications de son choix dans une interface console conviviale.

procedure Multiplications is
    
    generic
		Lower_Bound, Upper_Bound : Integer;	-- bounds in which random numbers are generated
		-- { Lower_Bound <= Upper_Bound }
	
	package Alea is
	
		-- Compute a random number in the range Lower_Bound..Upper_Bound.
		--
		-- Notice that Ada advocates the definition of a range type in such a case
		-- to ensure that the type reflects the real possible values.
		procedure Get_Random_Number (Resultat : out Integer);
	
	end Alea;

	
	package body Alea is
	
		subtype Intervalle is Integer range Lower_Bound..Upper_Bound;
	
		package  Generateur_P is
			new Ada.Numerics.Discrete_Random (Intervalle);
		use Generateur_P;
	
		Generateur : Generateur_P.Generator;
	
		procedure Get_Random_Number (Resultat : out Integer) is
		begin
			Resultat := Random (Generateur);
		end Get_Random_Number;
	
	begin
		Reset(Generateur);
	end Alea;


    --Permet de générer des nombres aléatoires entre 1 et 10 inclus
    package Mon_Alea is
        new Alea (1,10);
    use Mon_Alea;


    NumeroTable : Integer;          --Numero choisi par l'utilisateur de la table a reviser
    NombreErreur : Integer;         --Compteur pour le nombre d'erreur a chaque serie de multiplication
    Multiplicateur : Integer;       --Nombre choisi aleatoirement pour chaque multipication
    ReponseUtilisateur : Integer;   --Variable prenant la reponse de l'utilisateur pour chaque multiplications
    ReponseJuste : Boolean;         --Booléen pour détérminer si la réponse de l'utilisateur est juste ou non.
    ReponseContinuer : Character;   --Charactère renseigné par l'utilisateur pour indiquer si il souhaite rejouer
    SouhaiteRejouer : Boolean;      --Booléen qui permet de rélancer une partie ou non
    MultiplicateurAvant : Integer;  --Variable qui stocke le multiplicateur pour eviter de poser 2 fois la meme multiplication
    NOMBREQUESTIONS : Constant Integer := 10; --Constante qui gère le nombre de question par série
    TABLEMAX : Constant Integer := 10;        --Constante qui permet de choisir la table de multiplication maximale choisissable par l'utilisateur

    TempsAvant : Time;              --Mesure du temps avant calcul de multiplication
    TempsApres : Time;              --Mesure du temps apres calcul de multiplication
    DureeCalcul, DureeTot, DureeMax : Duration; --Durees permettants de decider si il vaut reviser une table
    TableAReviser : Integer;        --Numero de la table sur laquelle l'utilisateur a mis le plus de temps a repondre

begin

   loop
       --Demander a l'utilisateur la table qu'il souhaite réviser

        loop 
           Put("Table à réviser : ");
           Get (NumeroTable);
        exit when (NumeroTable >= 0 and NumeroTable <= TABLEMAX );
            Put_line("Impossible la table a reviser doit etre entre 0 et 10.");
        end loop;

       --Faire travailler une série de multiplication à l'utilisateur en comptant ses erreurs

        NombreErreur := 0;
        MultiplicateurAvant := 0;
        DureeMax := Duration (0);
        DureeTot := Duration (0);
        for i in 1..NOMBREQUESTIONS loop
            --Poser une multiplication
             loop
                Get_random_number(Multiplicateur);
             exit when (Multiplicateur /= MultiplicateurAvant); 
             end loop;
             MultiplicateurAvant := Multiplicateur;

             New_line;
             Put("M(" & Integer'image(i) & ") " & Integer'image(NumeroTable) & " *" & Integer'image(Multiplicateur) & " ? ");
             TempsAvant := Clock;       --Mesure du temps avant le get
             Get(ReponseUtilisateur);
             TempsApres := Clock;       --Mesure du temps apres le get
             ReponseJuste := ReponseUtilisateur = NumeroTable * Multiplicateur;
                        
            if ReponseJuste then
                Put_line("Bravo !");
            else
                Put_line("Mauvaise réponse");
                NombreErreur := NombreErreur + 1;
            end if;

            --Calcul de la duree de reponse a chaque question
             DureeCalcul := TempsApres - TempsAvant;
             if DureeCalcul > DureeMax then
                 DureeMax := DureeCalcul;
                 TableAReviser := Multiplicateur;
             else
                 null;
             end if;

             DureeTot := DureeTot + DureeCalcul;

        end loop;

       --Ecrire un message de fin suivant le nombre d'erreur

        case NombreErreur is
            when 0 => Put_line("Aucune erreur. Excellent !");
            when 1 => Put_line("Une seule erreur. Très bien.");
            when NOMBREQUESTIONS => Put_line("Tout est faux ! Volontaire ?");
            when 6..(NOMBREQUESTIONS-1) => Put_line("Seulement" & Integer'image(NOMBREQUESTIONS - NombreErreur) & " bonnes réponses. Il faut apprendre la table de" & Integer'image(NumeroTable));
            when others => Put_line(Integer'image(NombreErreur) & " erreurs. Il faut encore travailler la table de" & Integer'image(NumeroTable));
        end case;

       --Conseiller sur la table a reviser ensuite

        if DureeMax > DureeTot / 10 + Duration(1.0) then
            Put_line("Des hésitations sur la table de" & Integer'image(TableAReviser) & ":" & Duration'image(DureeMax) & " secondes contre" & Duration'image(DureeTot / 10) & " en moyenne. Il faut certainement la réviser.");
        else 
            null;
        end if;

       --Demander à l'utilisateur si il souhaite rejouer
        
        New_line;
        Put("On continue ? (o/n) ");
        Get(ReponseContinuer);
        SouhaiteRejouer := (ReponseContinuer='o' or ReponseContinuer='O');

   exit when not SouhaiteRejouer;
   end loop;

end Multiplications;
