-- WARNING: This schema is for context only and is not meant to be run.

-- Table order and constraints may not be valid for execution.

CREATE TABLE public.All\_Customers (

id integer NOT NULL DEFAULT nextval('"All\_Customers\_id\_seq"'::regclass),

customer\_id integer,

customer\_name text,

customer\_number text,

active boolean,

address\_1 text,

address\_2 text,

city text,

state text,

zip text,

contact\_name text,

phone text,

email text,

created\_at timestamp with time zone DEFAULT now(),

CONSTRAINT All\_Customers\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.admix\_incoming\_orders (

id integer NOT NULL DEFAULT nextval('admix\_incoming\_orders\_id\_seq'::regclass),

plant\_name text NOT NULL,

admix\_type text NOT NULL,

number\_of\_gallons integer NOT NULL,

estimated\_delivery\_date date,

order\_status text DEFAULT 'pending'::text,

entered\_by text NOT NULL,

notes text,

created\_at timestamp with time zone DEFAULT now(),

updated\_at timestamp with time zone DEFAULT now(),

CONSTRAINT admix\_incoming\_orders\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.admix\_inventory (

id integer NOT NULL DEFAULT nextval('admix\_inventory\_id\_seq'::regclass),

plant\_name text NOT NULL UNIQUE,

dv1000 numeric DEFAULT 0,

recover numeric DEFAULT 0,

isoflex7350 numeric DEFAULT 0,

isoflex8600 numeric DEFAULT 0,

isocure1000 numeric DEFAULT 0,

eclipse4500 numeric DEFAULT 0,

isoxel5400 numeric DEFAULT 0,

vmar3 numeric DEFAULT 0,

regularfiber numeric DEFAULT 0,

microfiber numeric DEFAULT 0,

xypex numeric DEFAULT 0,

expansionjoint numeric DEFAULT 0,

last\_drygoods\_check\_date text,

last\_drygoods\_check\_time text,

updated\_at timestamp with time zone DEFAULT now(),

last\_drygoods\_checked\_by text,

CONSTRAINT admix\_inventory\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.asphalt\_demand (

id bigint NOT NULL DEFAULT nextval('asphalt\_demand\_id\_seq'::regclass),

ship\_date date NOT NULL,

plant\_id integer NOT NULL,

plant\_description text NOT NULL,

product\_number text NOT NULL,

product\_description text NOT NULL,

quantity numeric NOT NULL,

unit text NOT NULL,

order\_status\_id integer,

fetched\_at timestamp with time zone DEFAULT now(),

division text,

CONSTRAINT asphalt\_demand\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.chameleon\_incoming\_orders (

id integer NOT NULL DEFAULT nextval('chameleon\_incoming\_orders\_id\_seq'::regclass),

plant\_name text NOT NULL,

color\_type text NOT NULL,

number\_of\_totes integer NOT NULL,

total\_pounds numeric NOT NULL,

estimated\_delivery\_date date,

order\_status text DEFAULT 'pending'::text,

entered\_by text NOT NULL,

notes text,

created\_at timestamp with time zone DEFAULT now(),

updated\_at timestamp with time zone DEFAULT now(),

CONSTRAINT chameleon\_incoming\_orders\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.chameleon\_inventory (

id integer NOT NULL DEFAULT nextval('chameleon\_inventory\_id\_seq'::regclass),

plant\_name text NOT NULL UNIQUE,

a1010 numeric NOT NULL DEFAULT 0,

a1070 numeric NOT NULL DEFAULT 0,

a550 numeric NOT NULL DEFAULT 0,

a875 numeric NOT NULL DEFAULT 0,

a8090 numeric NOT NULL DEFAULT 0,

last\_rinse\_date text,

last\_rinse\_time text,

updated\_at timestamp with time zone DEFAULT now(),

CONSTRAINT chameleon\_inventory\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.concrete\_demand (

id bigint NOT NULL DEFAULT nextval('concrete\_demand\_id\_seq'::regclass),

ship\_date date NOT NULL,

plant\_id integer NOT NULL,

plant\_description text NOT NULL,

product\_number text NOT NULL,

product\_description text NOT NULL,

quantity numeric NOT NULL,

unit text NOT NULL,

order\_status\_id integer,

fetched\_at timestamp with time zone DEFAULT now(),

division text,

CONSTRAINT concrete\_demand\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.cron\_job\_logs (

id bigint NOT NULL DEFAULT nextval('cron\_job\_logs\_id\_seq'::regclass),

job\_name text,

status text,

message text,

run\_at timestamp with time zone DEFAULT now(),

CONSTRAINT cron\_job\_logs\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.daily\_inventory (

id integer NOT NULL DEFAULT nextval('daily\_inventory\_id\_seq'::regclass),

material\_id character varying NOT NULL,

material\_name character varying NOT NULL,

location character varying NOT NULL,

value numeric,

timestamp timestamp with time zone DEFAULT now(),

entered\_by character varying,

entry\_date date DEFAULT CURRENT\_DATE,

CONSTRAINT daily\_inventory\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.data\_locking\_status (

id integer NOT NULL DEFAULT nextval('data\_locking\_status\_id\_seq'::regclass),

material\_id character varying NOT NULL,

entry\_date date NOT NULL,

is\_locked boolean NOT NULL DEFAULT false,

locked\_at timestamp with time zone,

locked\_by character varying,

created\_at timestamp with time zone DEFAULT now(),

CONSTRAINT data\_locking\_status\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.driver\_schedules (

id bigint NOT NULL DEFAULT nextval('driver\_schedules\_id\_seq'::regclass),

schedule\_id text,

driver\_name text,

driver\_id text,

schedule\_date date,

start\_time timestamp with time zone,

end\_time timestamp with time zone,

route\_name text,

vehicle\_id text,

status text,

raw\_data jsonb,

fetched\_at timestamp with time zone DEFAULT now(),

work\_point text,

truck\_name text,

active boolean DEFAULT true,

CONSTRAINT driver\_schedules\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.profit\_margin\_report (

id bigint NOT NULL DEFAULT nextval('profit\_margin\_report\_id\_seq'::regclass),

customer\_id integer,

customer\_number text,

customer\_name text NOT NULL,

customer\_order\_id integer,

job\_id integer,

job\_number text,

job\_name text,

ship\_date date NOT NULL,

quote\_id integer,

quote\_number text,

plant\_id integer,

product\_id integer,

product\_name text,

quantity numeric,

revenue numeric NOT NULL DEFAULT 0,

material\_cost numeric NOT NULL DEFAULT 0,

delivery\_cost numeric NOT NULL DEFAULT 0,

fixed\_cost numeric NOT NULL DEFAULT 0,

net\_profit numeric NOT NULL DEFAULT 0,

margin\_percent numeric NOT NULL DEFAULT 0,

haul\_minutes integer,

created\_at timestamp with time zone DEFAULT now(),

updated\_at timestamp with time zone DEFAULT now(),

CONSTRAINT profit\_margin\_report\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.raw\_material\_demands (

id bigint NOT NULL DEFAULT nextval('raw\_material\_demands\_id\_seq'::regclass),

plant\_name text NOT NULL,

material\_category text NOT NULL,

material\_name text NOT NULL,

demand\_date date NOT NULL,

quantity\_tons numeric NOT NULL,

created\_at timestamp with time zone DEFAULT timezone('utc'::text, now()),

updated\_at timestamp with time zone DEFAULT timezone('utc'::text, now()),

plant\_id integer,

division text,

CONSTRAINT raw\_material\_demands\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.third\_party\_access\_status (

id integer NOT NULL DEFAULT nextval('third\_party\_access\_status\_id\_seq'::regclass),

location\_name character varying NOT NULL,

entry\_date date NOT NULL,

is\_ready\_for\_3rd\_party boolean NOT NULL DEFAULT false,

all\_sections\_complete boolean NOT NULL DEFAULT false,

ready\_at timestamp with time zone,

created\_at timestamp with time zone DEFAULT now(),

CONSTRAINT third\_party\_access\_status\_pkey PRIMARY KEY (id)

);

CREATE TABLE public.trucks (

truck\_id text NOT NULL,

truck\_name text,

truck\_class\_name text,

vin text,

active boolean,

home\_point\_id text,

raw\_data jsonb,

last\_updated timestamp with time zone DEFAULT now(),

CONSTRAINT trucks\_pkey PRIMARY KEY (truck\_id)

);

CREATE TABLE public.users (

user\_id text NOT NULL,

user\_name text,

email text,

role text,

active boolean,

raw\_data jsonb,

last\_updated timestamp with time zone DEFAULT now(),

work\_point text,

CONSTRAINT users\_pkey PRIMARY KEY (user\_id)

);

CREATE TABLE public.weekly\_completion\_tracking (

id integer NOT NULL DEFAULT nextval('weekly\_completion\_tracking\_id\_seq'::regclass),

location\_name character varying NOT NULL,

week\_start\_date date NOT NULL,

completion\_percentage integer NOT NULL DEFAULT 0,

completed\_materials integer NOT NULL DEFAULT 0,

total\_materials integer NOT NULL DEFAULT 0,

last\_updated timestamp with time zone DEFAULT now(),

created\_at timestamp with time zone DEFAULT now(),

CONSTRAINT weekly\_completion\_tracking\_pkey PRIMARY KEY (id)

);
