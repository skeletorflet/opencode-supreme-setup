---
name: react-hook-form
description: React Hook Form — performant form management with uncontrolled inputs, validation, and field arrays.
---

## react-hook-form

### useForm & Register
- `useForm({ defaultValues: { name: '' } })` — initialize form context.
- `register('name', { required: true })` — spread into `<input>` for uncontrolled binding.
- `register('email', { pattern: /^\S+@\S+$/ })` — inline validation rules.
- `register('age', { valueAsNumber: true })` — automatic type coercion.

### Validation
- Native rules: `required`, `minLength`, `maxLength`, `min`, `max`, `pattern`, `validate`.
- `validate: (val) => val.length > 3 || 'too short'` — custom sync/async validator.
- Schema validation: `zodResolver(schema)` / `yupResolver(schema)` from `@hookform/resolvers`.
- `shouldUseNativeValidation: true` — browser-native validation messages.

### Errors & Form State
- `formState.errors.name?.message` — per-field error object from validation.
- `formState.isDirty`, `isSubmitting`, `isValid`, `submitCount` — reactive form state.
- `trigger('email')` — manually validate a single field.
- `setError('name', { message: 'taken' })` — server-side validation errors.

### useFieldArray
- `useFieldArray({ control, name: 'items' })` — dynamic list of fields.
- `fields.map((item, i) => <input key={item.id} {...register(`items.${i}.value`)} />)`.
- Methods: `append`, `prepend`, `remove`, `insert`, `swap`, `move`, `replace`.
- Each field needs unique `id` from `fields` array (not index as key).

### Controller & Performance
- `<Controller render={({ field }) => <Select {...field} />} name="country" control={control} />`.
- Uncontrolled inputs = minimal re-renders; `Controller` for custom/third-party components.
- `useWatch({ name: 'field' })` — subscribe to field changes without re-render.
- `useFormContext()` / `<FormProvider>` — shared form context for deeply nested components.
