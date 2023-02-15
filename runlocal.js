import { createMapper } from './step.js'

const triplify = await createMapper()

const result = await triplify({
  mappingFile: './src-gen/mapping.rml.ttl', outputFile: 'output.ttl',
})

console.log(result)
