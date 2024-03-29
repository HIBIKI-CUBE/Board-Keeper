
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

CREATE SCHEMA IF NOT EXISTS "public";

ALTER SCHEMA "public" OWNER TO "pg_database_owner";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."Boards" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "owner" "uuid" DEFAULT "gen_random_uuid"()
);

ALTER TABLE "public"."Boards" OWNER TO "postgres";

ALTER TABLE "public"."Boards" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."Boards_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."Items" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "deadline" timestamp with time zone,
    "lane" bigint,
    "row" bigint
);

ALTER TABLE "public"."Items" OWNER TO "postgres";

COMMENT ON TABLE "public"."Items" IS 'aka Kanban';

ALTER TABLE "public"."Items" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."Items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."Lanes" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "board" bigint,
    "runsTimer" boolean DEFAULT false NOT NULL
);

ALTER TABLE "public"."Lanes" OWNER TO "postgres";

COMMENT ON TABLE "public"."Lanes" IS 'aka Column';

ALTER TABLE "public"."Lanes" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."Lanes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE IF NOT EXISTS "public"."Logs" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "started_at" timestamp with time zone DEFAULT "now"(),
    "stopped_at" timestamp with time zone,
    "item" bigint
);

ALTER TABLE "public"."Logs" OWNER TO "postgres";

ALTER TABLE "public"."Logs" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."Logs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY "public"."Boards"
    ADD CONSTRAINT "Boards_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Items"
    ADD CONSTRAINT "Items_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Lanes"
    ADD CONSTRAINT "Lanes_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Logs"
    ADD CONSTRAINT "Logs_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."Boards"
    ADD CONSTRAINT "public_Boards_owner_fkey" FOREIGN KEY ("owner") REFERENCES "auth"."users"("id");

ALTER TABLE ONLY "public"."Items"
    ADD CONSTRAINT "public_Items_lane_fkey" FOREIGN KEY ("lane") REFERENCES "public"."Lanes"("id");

ALTER TABLE ONLY "public"."Lanes"
    ADD CONSTRAINT "public_Lanes_board_fkey" FOREIGN KEY ("board") REFERENCES "public"."Boards"("id");

ALTER TABLE ONLY "public"."Logs"
    ADD CONSTRAINT "public_Logs_item_fkey" FOREIGN KEY ("item") REFERENCES "public"."Items"("id");

ALTER TABLE "public"."Boards" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."Items" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."Lanes" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."Logs" ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."Boards" TO "anon";
GRANT ALL ON TABLE "public"."Boards" TO "authenticated";
GRANT ALL ON TABLE "public"."Boards" TO "service_role";

GRANT ALL ON SEQUENCE "public"."Boards_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Boards_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Boards_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."Items" TO "anon";
GRANT ALL ON TABLE "public"."Items" TO "authenticated";
GRANT ALL ON TABLE "public"."Items" TO "service_role";

GRANT ALL ON SEQUENCE "public"."Items_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Items_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Items_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."Lanes" TO "anon";
GRANT ALL ON TABLE "public"."Lanes" TO "authenticated";
GRANT ALL ON TABLE "public"."Lanes" TO "service_role";

GRANT ALL ON SEQUENCE "public"."Lanes_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Lanes_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Lanes_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."Logs" TO "anon";
GRANT ALL ON TABLE "public"."Logs" TO "authenticated";
GRANT ALL ON TABLE "public"."Logs" TO "service_role";

GRANT ALL ON SEQUENCE "public"."Logs_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."Logs_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."Logs_id_seq" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
