/*
 * Copyright (C) 1999  Internet Software Consortium.
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND INTERNET SOFTWARE CONSORTIUM DISCLAIMS
 * ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL INTERNET SOFTWARE
 * CONSORTIUM BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
 * PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
 * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 */

#ifndef DNS_RDATASETITER_H
#define DNS_RDATASETITER_H 1

/*****
 ***** Module Info
 *****/

/*
 * DNS Rdataset Iterator
 *
 * The DNS Rdataset Iterator interface allows iteration of all of the
 * rdatasets at a node.
 *
 * The dns_rdatasetiter_t type is like a "virtual class".  To actually use
 * it, an implementation of the class is required.  This implementation is
 * supplied by the database.
 *
 * It is the client's responsibility to call dns_db_detachnode() on all
 * nodes returned.
 *
 * XXX <more> XXX
 *
 * MP:
 *	The iterator itself is not locked.  The caller must ensure
 *	synchronization.
 *	
 *	The iterator methods ensure appropriate database locking.
 *
 * Reliability:
 *	No anticipated impact.
 *
 * Resources:
 *	<TBS>
 *
 * Security:
 *	No anticipated impact.
 *
 * Standards:
 *	None.
 */

/*****
 ***** Imports
 *****/

#include <isc/boolean.h>
#include <isc/buffer.h>
#include <isc/lang.h>

#include <dns/types.h>
#include <dns/result.h>

ISC_LANG_BEGINDECLS

/*****
 ***** Types
 *****/

typedef struct dns_rdatasetitermethods {
	void		(*destroy)(dns_rdatasetiter_t **iteratorp);
	dns_result_t	(*first)(dns_rdatasetiter_t *iterator);
	dns_result_t	(*next)(dns_rdatasetiter_t *iterator);
	dns_result_t	(*current)(dns_rdatasetiter_t *iterator,
				   dns_rdataset_t *rdataset);
} dns_rdatasetitermethods_t;

#define DNS_RDATASETITER_MAGIC		0x444E5369U		/* DNSi. */
#define DNS_RDATASETITER_VALID(dbi)	((dbi) != NULL && \
					 (dbi)->magic == \
					 DNS_RDATASETITER_MAGIC)

/*
 * This structure is actually just the common prefix of a DNS db
 * implementation's version of a dns_rdatasetiter_t.
 *
 * Direct use of this structure by clients is forbidden.  DB implementations
 * may change the structure.  'magic' must be DNS_RDATASETITER_MAGIC for
 * any of the dns_rdatasetiter routines to work.  DB implementations must
 * maintain all DB rdataset iterator invariants.
 */
struct dns_rdatasetiter {
	/* Unlocked. */
	unsigned int			magic;
	dns_rdatasetitermethods_t *	methods;
	dns_db_t *			db;
	dns_dbnode_t *			node;
	dns_dbversion_t *		version;
};

void
dns_rdatasetiter_destroy(dns_rdatasetiter_t **iteratorp);
/*
 * Destroy '*iteratorp'.
 *
 * Requires:
 *
 *	'*iteratorp' is a valid iterator.
 *
 * Ensures:
 *
 *	All resources used by the iterator are freed.
 *
 *	*iteratorp == NULL.
 */

dns_result_t
dns_rdatasetiter_first(dns_rdatasetiter_t *iterator);
/*
 * Move the rdataset cursor to the first rdataset at the node (if any).
 *
 * Requires:
 *	'iterator' is a valid iterator.
 *
 * Returns:
 *	DNS_R_SUCCESS
 *	DNS_R_NOMORE			There are no rdatasets at the node.
 *
 *	Other results are possible, depending on the DB implementation.
 */

dns_result_t
dns_rdatasetiter_next(dns_rdatasetiter_t *iterator);
/*
 * Move the rdataset cursor to the next rdataset at the node (if any).
 *
 * Requires:
 *	'iterator' is a valid iterator.
 *
 * Returns:
 *	DNS_R_SUCCESS
 *	DNS_R_NOMORE			There are no more rdatasets at the
 *					node.
 *
 *	Other results are possible, depending on the DB implementation.
 */

dns_result_t
dns_rdatasetiter_current(dns_rdatasetiter_t *iterator,
			 dns_rdataset_t *rdataset);
/*
 * Return the current rdataset.
 *
 * Requires:
 *	'iterator' is a valid iterator.
 *
 *	'rdataset' is a valid, disassociated rdataset.
 *
 *	The rdataset cursor of 'iterator' is at a valid location (i.e. the
 *	result of last call to a cursor movement command was DNS_R_SUCCESS).
 *
 * Returns:
 *
 *	DNS_R_SUCCESS
 *
 *	Other results are possible, depending on the DB implementation.
 */

ISC_LANG_ENDDECLS

#endif /* DNS_RDATASETITER_H */
