/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.ja-sig.org/products/cas/overview/license/
 */
package org.jasig.cas.adaptors.cas;

import javax.servlet.http.HttpServletRequest;

import org.jasig.cas.authentication.principal.Credentials;
import org.jasig.cas.web.bind.CredentialsBinder;

/**
 * Custom Binder to populate the Legacy CAS Credentials with the required
 * ServletRequest.
 * 
 * @author Scott Battaglia
 * @version $Revision: 14064 $ $Date: 2007-06-10 09:17:55 -0400 (Sun, 10 Jun 2007) $
 * @since 3.0
 */
public final class LegacyCasCredentialsBinder implements CredentialsBinder {

    public void bind(final HttpServletRequest request,
        final Credentials credentials) {
        if (credentials.getClass().equals(LegacyCasCredentials.class)) {
            ((LegacyCasCredentials) credentials).setServletRequest(request);
        } else {
            ((LegacyCasTrustedCredentials) credentials)
                .setServletRequest(request);
        }
    }

    public boolean supports(final Class<?> clazz) {
        return !(clazz == null)
            && (clazz.equals(LegacyCasCredentials.class) || clazz
                .equals(LegacyCasTrustedCredentials.class));
    }

}
