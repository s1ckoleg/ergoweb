# Install dependencies only when needed
FROM node:alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY . .
RUN npm ci
# RUN yarn build && yarn install --production --ignore-scripts --prefer-offline
RUN NEXT_PUBLIC_STRAPI_API=APP_NEXT_PUBLIC_STRAPI_API \
    npm run build

ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
 
USER nextjs

EXPOSE 3000

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry.
ENV NEXT_TELEMETRY_DISABLED 1

RUN npx next telemetry disable

# CMD ["yarn", "start"]
ENTRYPOINT ["sh", "/app/entrypoint.sh"]

CMD ["npm", "run", "start"]