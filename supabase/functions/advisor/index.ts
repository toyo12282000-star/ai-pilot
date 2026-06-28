// AI Pilot Advisor Edge Function (Sprint 11.4)
// MVP: returns mock recommendations. Replace with OpenAI Responses API later.

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface WorkflowPayload {
  id: string;
  title: string;
  description: string;
  tags?: string[];
  categoryId?: string;
}

interface AdvisorRequest {
  query: string;
  workflows: WorkflowPayload[];
}

interface AdvisorResponse {
  recommendationIds: string[];
  reason: string;
}

function normalize(value: string): string {
  return value.toLowerCase().trim();
}

function stripIntentSuffix(query: string): string {
  return query
    .replace(
      /(を始めたい|を作りたい|を書きたい|を伸ばしたい|したい|始めたい|作りたい|学びたい|運用したい)$/,
      "",
    )
    .trim();
}

function scoreWorkflow(
  query: string,
  workflow: WorkflowPayload,
): number {
  const normalizedQuery = normalize(query);
  if (!normalizedQuery) {
    return 0;
  }

  const intentCore = stripIntentSuffix(normalizedQuery);
  const title = normalize(workflow.title);
  const description = normalize(workflow.description);
  const tags = (workflow.tags ?? []).map(normalize);

  let score = 0;

  if (title.includes(normalizedQuery) || normalizedQuery.includes(title)) {
    score += 40;
  }
  if (intentCore.length >= 2 && title.includes(intentCore)) {
    score += 35;
  }
  if (description.includes(normalizedQuery)) {
    score += 25;
  }
  if (intentCore.length >= 2 && description.includes(intentCore)) {
    score += 20;
  }

  for (const tag of tags) {
    if (
      tag.includes(normalizedQuery) ||
      normalizedQuery.includes(tag) ||
      (intentCore.length >= 2 && tag.includes(intentCore))
    ) {
      score += 20;
    }
  }

  return score;
}

function mockSuggest(
  query: string,
  workflows: WorkflowPayload[],
): AdvisorResponse {
  const normalizedQuery = normalize(query);
  if (!normalizedQuery) {
    return {
      recommendationIds: [],
      reason: "相談内容を入力してください",
    };
  }

  const ranked = workflows
    .map((workflow) => ({
      id: workflow.id,
      score: scoreWorkflow(query, workflow),
    }))
    .filter((item) => item.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, 3);

  if (ranked.length === 0) {
    return {
      recommendationIds: [],
      reason: "近いWorkflowが見つかりませんでした",
    };
  }

  return {
    recommendationIds: ranked.map((item) => item.id),
    reason: "入力内容に近いWorkflowとして選びました",
  };
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  try {
    const body = (await req.json()) as AdvisorRequest;
    const query = body.query ?? "";
    const workflows = Array.isArray(body.workflows) ? body.workflows : [];

    // TODO(Sprint 12+): Replace mockSuggest with OpenAI Responses API call.
    // - Use Deno.env.get("OPENAI_API_KEY") (Edge Function secret only)
    // - Send structured prompt with query + workflow catalog
    // - Parse model output into recommendationIds + reason
    const result = mockSuggest(query, workflows);

    return new Response(JSON.stringify(result), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return new Response(JSON.stringify({ error: message }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
