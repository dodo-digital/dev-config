---
name: vercel-react
description: React and Next.js best practices from Vercel Engineering (40+ optimization rules). Use when writing React components, Next.js pages, reviewing frontend code, or optimizing bundle size and performance.
---

<auto_trigger>
- "react", "nextjs", "next.js", "next js"
- "component", "components", "jsx", "tsx"
- "server component", "client component", "use client", "use server"
- "suspense", "streaming", "ssr", "server side"
- "bundle size", "tree shaking", "code splitting"
- "waterfall", "parallel fetch", "promise.all"
- "barrel import", "barrel file"
- Writing React code
- Reviewing frontend performance
- Optimizing Next.js app
</auto_trigger>

<objective>
Apply Vercel's React and Next.js performance best practices when writing, reviewing, or refactoring code. This skill encapsulates 10+ years of optimization knowledge into actionable rules.
</objective>

<when_to_use>
- Writing new React components or Next.js pages
- Implementing data fetching patterns
- Reviewing code for performance issues
- Refactoring existing React/Next.js code
- Optimizing bundle size or render performance
</when_to_use>

<critical_rules>

## CRITICAL: Eliminating Waterfalls

Waterfalls are the #1 performance killer. Each sequential await adds full network latency.

**❌ BAD - Sequential fetches (waterfall)**
```typescript
async function Page() {
  const user = await getUser();      // 200ms
  const posts = await getPosts();    // 200ms
  const comments = await getComments(); // 200ms
  // Total: 600ms
}
```

**✅ GOOD - Parallel fetches**
```typescript
async function Page() {
  const [user, posts, comments] = await Promise.all([
    getUser(),
    getPosts(),
    getComments()
  ]);
  // Total: 200ms (max of all three)
}
```

## CRITICAL: Bundle Size

Barrel imports can add 200-800ms to cold starts.

**❌ BAD - Barrel import**
```typescript
import { Button } from '@/components';
import { ChevronRight } from 'lucide-react';
```

**✅ GOOD - Direct imports**
```typescript
import Button from '@/components/Button';
import ChevronRight from 'lucide-react/dist/esm/icons/chevron-right';
```

**Or configure Next.js:**
```javascript
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: ['lucide-react', '@heroicons/react']
  }
}
```

</critical_rules>

<high_priority_rules>

## Server Actions Need Auth

Server Actions are exposed as public POST endpoints. Always authenticate.

**❌ BAD - No auth check**
```typescript
'use server'
async function deletePost(id: string) {
  await db.posts.delete(id);
}
```

**✅ GOOD - Auth inside action**
```typescript
'use server'
async function deletePost(id: string) {
  const user = await auth();
  if (!user) throw new Error('Unauthorized');

  const post = await db.posts.findUnique({ where: { id } });
  if (post.authorId !== user.id) throw new Error('Forbidden');

  await db.posts.delete({ where: { id } });
}
```

## Strategic Suspense Boundaries

Wrap dynamic content in Suspense for faster initial paint.

```typescript
export default function Page() {
  return (
    <div>
      <Header /> {/* Static - renders immediately */}

      <Suspense fallback={<ProductSkeleton />}>
        <ProductList /> {/* Dynamic - streams in */}
      </Suspense>

      <Footer /> {/* Static - renders immediately */}
    </div>
  );
}
```

</high_priority_rules>

<medium_priority_rules>

## Avoid Re-render Storms

**❌ BAD - Object literals in JSX**
```typescript
<Component style={{ color: 'red' }} /> // New object every render
```

**✅ GOOD - Stable references**
```typescript
const style = { color: 'red' }; // Outside component or useMemo
<Component style={style} />
```

**❌ BAD - Effect dependency issues**
```typescript
useEffect(() => {
  fetchData(filters);
}, [filters]); // If filters is new object each render = infinite loop
```

**✅ GOOD - Primitive dependencies**
```typescript
const filterKey = JSON.stringify(filters);
useEffect(() => {
  fetchData(filters);
}, [filterKey]);
```

## RSC Payload Size

Only pass what the client needs across the server/client boundary.

**❌ BAD - Passing entire objects**
```typescript
// Server Component
<ClientComponent user={fullUserObject} /> // 50+ fields serialized
```

**✅ GOOD - Pick needed fields**
```typescript
// Server Component
<ClientComponent
  userName={user.name}
  userAvatar={user.avatar}
/>
```

</medium_priority_rules>

<quick_reference>

| Category | Impact | Key Rule |
|----------|--------|----------|
| Waterfalls | CRITICAL | Use Promise.all, not sequential awaits |
| Bundle | CRITICAL | Direct imports, not barrel files |
| Server Auth | HIGH | Always auth inside Server Actions |
| Suspense | HIGH | Wrap dynamic content for streaming |
| Re-renders | MEDIUM | Stable refs, primitive deps |
| RSC Payload | MEDIUM | Only pass needed fields to client |

</quick_reference>

<success_criteria>
- [ ] No sequential awaits that could be parallelized
- [ ] No barrel imports from large packages
- [ ] Server Actions have explicit auth checks
- [ ] Dynamic content wrapped in Suspense
- [ ] No object literals creating new refs each render
</success_criteria>

<references>
- [Vercel React Best Practices](https://github.com/vercel-labs/agent-skills/tree/main/skills/react-best-practices)
- [Next.js Performance Docs](https://nextjs.org/docs/app/building-your-application/optimizing)
- [React Server Components](https://react.dev/reference/rsc/server-components)
</references>
