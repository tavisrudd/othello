# C909 Google Scholar checklist

Date: 2026-08-12

## What to run in Publish or Perish

Choose **Google Scholar → General/keyword search**.

For discovery searches, put the complete query in **Keywords**.  Leave
Title words, Authors, Publication, and years blank.  Run each query
separately.

### Cycle searches

```text
"finite étale" "Néron-Severi" graph isogeny
```

```text
"integral Hodge" "product of elliptic curves" divisor -K3 -hyperkähler
```

```text
"Hodge classes" "power of an elliptic curve" integral
```

```text
"Lefschetz classes" "elliptic curves" integral
```

```text
"products of divisor classes" "abelian varieties" integral
```

```text
"integral Hodge conjecture" "product of elliptic curves"
```

### Quantum searches

```text
"cubic threefold" "P^1" irrational
```

```text
"V14" "P^1" irrational
```

```text
"primitive sixth" "formal monodromy" quantum
```

```text
"degree 14" Fano "stable rationality" quantum
```

## Cited-by searches

To find a seed, use **Google Scholar → General/keyword search**, put its exact
title in **Title words**, run the search, select the exact record, right-click,
and choose **Retrieve citing works**.

Priority seeds:

1. `Lefschetz classes on abelian varieties`
2. `The tropical positive semidefinite cone`
3. `Integral Fourier transforms and the integral Hodge conjecture for
   one-cycles on abelian varieties`
4. `The Fano surface of the Klein cubic threefold`
5. `Derived categories of cubic and V14 threefolds`
6. `Birational Invariants from Hodge Structures and Quantum Multiplication`
7. `The cubic threefold is symplectically irrational`

## What to save

For every search or cited-by set, save:

* the complete **CSV**;
* the **search report** as RTF;
* BibTeX only if convenient;
* the exact submitted query and any displayed result count.

Put the files in `/tmp/google-scholar/`.  Do not rename files already there.
Do not supply credentials, cookies, account data, or payment information.

Zero-result searches are useful: save their RTF search report too.

## DeepDyve

Do not download papers speculatively.  After the CSV screen, the paper audit
will produce an exact DOI and page-range request for any paywalled candidate
that needs reading.  Open-access and publisher PDFs are preferred.  A
lawfully purchased DeepDyve PDF may be placed in `/tmp/google-scholar/pdf/`;
a rented-page browser print should not be shared.

## Current intake

The two initial 200-row CSVs in `/tmp/google-scholar/` have been received and
are being screened.  Both reached Publish or Perish's 200-result ceiling, so
they are recorded as bounded top-200 result sets rather than exhaustive
searches.
