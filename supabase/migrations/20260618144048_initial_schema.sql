-- Create users table (maps to Supabase auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR NOT NULL UNIQUE,
    display_name VARCHAR NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create groups table
CREATE TABLE public.groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR NOT NULL,
    gift_exchange_date TIMESTAMPTZ NOT NULL,
    min_budget DECIMAL(10,2) NOT NULL,
    max_budget DECIMAL(10,2) NOT NULL,
    status VARCHAR NOT NULL DEFAULT 'WAITING' CHECK (status IN ('WAITING', 'DRAWN', 'CANCELED')),
    creator_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create group_members table
CREATE TABLE public.group_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    wishlist TEXT,
    role VARCHAR NOT NULL DEFAULT 'PARTICIPANT' CHECK (role IN ('ADMIN', 'PARTICIPANT')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(group_id, user_id)
);

-- Create exclusion_rules table
CREATE TABLE public.exclusion_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    giver_id UUID NOT NULL REFERENCES public.group_members(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.group_members(id) ON DELETE CASCADE,
    UNIQUE(giver_id, receiver_id),
    CHECK (giver_id != receiver_id)
);

-- Create draw_results table
CREATE TABLE public.draw_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    giver_id UUID NOT NULL REFERENCES public.group_members(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.group_members(id) ON DELETE CASCADE,
    revealed_at TIMESTAMPTZ,
    UNIQUE(group_id, giver_id),
    UNIQUE(group_id, receiver_id),
    CHECK (giver_id != receiver_id)
);

-- Create anonymous_messages table
CREATE TABLE public.anonymous_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exclusion_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.draw_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.anonymous_messages ENABLE ROW LEVEL SECURITY;

-- 4.3. Regras de Migração e Operações Seguras (Zero-Downtime)
-- A tabela DrawResult deve possuir políticas de RLS extremamente rígidas
-- RLS: leitura apenas se auth.uid() == DrawResult.giverId->User.id
CREATE POLICY "Leitura de sorteio restrita ao próprio giver"
ON public.draw_results
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.group_members gm
        WHERE gm.id = draw_results.giver_id
        AND gm.user_id = auth.uid()
    )
);
